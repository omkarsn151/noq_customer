import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/bookings/bloc/bookings_event.dart';
import 'package:noq/features/bookings/bloc/bookings_state.dart';
import 'package:noq/features/bookings/repository/bookings_repository.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  final BookingsRepository _repository;

  BookingsBloc(this._repository) : super(const BookingsState()) {
    on<BookingsRequested>(_onBookingsRequested);
    on<BookingsRefreshRequested>(_onRefreshRequested);
    on<BookingsNextPageRequested>(_onNextPageRequested);
  }

  Future<void> _onRefreshRequested(
    BookingsRefreshRequested event,
    Emitter<BookingsState> emit,
  ) async {
    emit(const BookingsState());
    add(BookingsRequested(tab: event.tab, refresh: true));
  }

  Future<void> _onBookingsRequested(
    BookingsRequested event,
    Emitter<BookingsState> emit,
  ) async {
    final tab = state.tabFor(event.tab);

    // Tabs keep their bookings once loaded, so switching back is instant.
    // A load already under way is left alone too, so a tab that asks for
    // itself while it is filling does not fetch the same page twice.
    if (!event.refresh &&
        (tab.status == BookingsTabStatus.success ||
            tab.status == BookingsTabStatus.loading)) {
      return;
    }

    emit(
      state.copyWithTab(
        event.tab,
        tab.copyWith(status: BookingsTabStatus.loading, message: ''),
      ),
    );

    try {
      final page = await _repository.getBookings(tab: event.tab);
      emit(
        state.copyWithTab(
          event.tab,
          BookingsTabState(
            status: BookingsTabStatus.success,
            bookings: page.items,
            meta: page.meta,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWithTab(
          event.tab,
          tab.copyWith(
            status: BookingsTabStatus.failure,
            message: _messageOf(e),
          ),
        ),
      );
    }
  }

  Future<void> _onNextPageRequested(
    BookingsNextPageRequested event,
    Emitter<BookingsState> emit,
  ) async {
    final tab = state.tabFor(event.tab);
    if (tab.isLoadingMore ||
        !tab.hasMore ||
        tab.status != BookingsTabStatus.success) {
      return;
    }

    emit(state.copyWithTab(event.tab, tab.copyWith(isLoadingMore: true)));

    try {
      final page = await _repository.getBookings(
        tab: event.tab,
        page: tab.meta.page + 1,
      );
      emit(
        state.copyWithTab(
          event.tab,
          tab.copyWith(
            bookings: [...tab.bookings, ...page.items],
            meta: page.meta,
            isLoadingMore: false,
          ),
        ),
      );
    } catch (e) {
      // Keep the loaded pages on screen and surface the message inline.
      emit(
        state.copyWithTab(
          event.tab,
          tab.copyWith(isLoadingMore: false, message: _messageOf(e)),
        ),
      );
    }
  }

  String _messageOf(Object error) =>
      error is ApiException ? error.message : error.toString();
}
