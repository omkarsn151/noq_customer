import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/bookings/bloc/bookings_event.dart';
import 'package:noq/features/bookings/bloc/bookings_state.dart';
import 'package:noq/features/bookings/data/booking_tab.dart';
import 'package:noq/features/bookings/repository/bookings_repository.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  static const int _pageSize = 10;

  final BookingsRepository _repository;

  BookingsBloc(this._repository) : super(const BookingsInitial()) {
    on<BookingsRequested>(_onBookingsRequested);
    on<BookingsTabChanged>(_onTabChanged);
    on<BookingsRefreshed>(_onRefreshed);
    on<BookingsNextPageRequested>(_onNextPageRequested);
  }

  Future<void> _onBookingsRequested(
    BookingsRequested event,
    Emitter<BookingsState> emit,
  ) async {
    emit(const BookingsLoading());
    await _loadFirstPage(event.tab, emit, emitFailureState: true);
  }

  Future<void> _onTabChanged(
    BookingsTabChanged event,
    Emitter<BookingsState> emit,
  ) async {
    final current = state;

    if (current is BookingsLoaded) {
      if (current.tab == event.tab) return;
      // Keep the old list on screen under a spinner rather than blanking it.
      emit(
        current.copyWith(
          tab: event.tab,
          isTabLoading: true,
          isPageLoading: false,
          pageError: null,
        ),
      );
      await _loadFirstPage(event.tab, emit, emitFailureState: false);
      return;
    }

    // Coming from a failed or not-yet-loaded screen: a full reload is the only
    // sensible thing, so a failure may replace the screen again.
    if (current is BookingsFailure && current.tab == event.tab) return;
    emit(const BookingsLoading());
    await _loadFirstPage(event.tab, emit, emitFailureState: true);
  }

  Future<void> _onRefreshed(
    BookingsRefreshed event,
    Emitter<BookingsState> emit,
  ) async {
    final current = state;
    final tab = switch (current) {
      BookingsLoaded() => current.tab,
      BookingsFailure() => current.tab,
      _ => BookingTab.upcoming,
    };

    if (current is BookingsLoaded) {
      if (current.isTabLoading) return;
      emit(current.copyWith(isPageLoading: false, pageError: null));
      await _loadFirstPage(tab, emit, emitFailureState: false);
      return;
    }

    emit(const BookingsLoading());
    await _loadFirstPage(tab, emit, emitFailureState: true);
  }

  Future<void> _onNextPageRequested(
    BookingsNextPageRequested event,
    Emitter<BookingsState> emit,
  ) async {
    final current = state;
    if (current is! BookingsLoaded) return;
    if (current.isTabLoading || current.isPageLoading) return;
    if (current.hasReachedEnd) return;

    final tab = current.tab;
    final nextPage = current.meta.page + 1;

    emit(current.copyWith(isPageLoading: true, pageError: null));

    try {
      final result = await _repository.getBookings(
        tab: tab,
        page: nextPage,
        pageSize: _pageSize,
      );
      final latest = state;
      // Drop the response if the customer has since switched tabs.
      if (latest is! BookingsLoaded || latest.tab != tab) return;
      emit(
        latest.copyWith(
          bookings: [...latest.bookings, ...result.items],
          meta: result.meta,
          isPageLoading: false,
        ),
      );
    } on ApiException catch (e) {
      _emitPageError(emit, tab, e.message);
    } catch (e) {
      _emitPageError(emit, tab, e.toString());
    }
  }

  /// Fetches page 1 of [tab] and replaces the list. When [emitFailureState] is
  /// false a failure is reported inline so the existing list stays on screen.
  Future<void> _loadFirstPage(
    BookingTab tab,
    Emitter<BookingsState> emit, {
    required bool emitFailureState,
  }) async {
    try {
      final result = await _repository.getBookings(
        tab: tab,
        page: 1,
        pageSize: _pageSize,
      );
      final latest = state;
      // Drop the response if the customer has since switched tabs.
      if (latest is BookingsLoaded && latest.tab != tab) return;
      emit(
        BookingsLoaded(tab: tab, bookings: result.items, meta: result.meta),
      );
    } on ApiException catch (e) {
      _emitFirstPageError(emit, tab, e.message, emitFailureState);
    } catch (e) {
      _emitFirstPageError(emit, tab, e.toString(), emitFailureState);
    }
  }

  void _emitFirstPageError(
    Emitter<BookingsState> emit,
    BookingTab tab,
    String message,
    bool emitFailureState,
  ) {
    final latest = state;
    if (latest is BookingsLoaded && latest.tab != tab) return;

    if (emitFailureState || latest is! BookingsLoaded) {
      emit(BookingsFailure(message: message, tab: tab));
      return;
    }
    emit(latest.copyWith(isTabLoading: false, pageError: message));
  }

  void _emitPageError(
    Emitter<BookingsState> emit,
    BookingTab tab,
    String message,
  ) {
    final latest = state;
    if (latest is! BookingsLoaded || latest.tab != tab) return;
    emit(latest.copyWith(isPageLoading: false, pageError: message));
  }
}
