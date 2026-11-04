import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/search/bloc/search_services_event.dart';
import 'package:noq/features/search/bloc/search_services_state.dart';
import 'package:noq/features/search/repository/search_repository.dart';

/// "See all services" for a search: every matching service, page by page.
class SearchServicesBloc
    extends Bloc<SearchServicesEvent, SearchServicesState> {
  final SearchRepository _repository;

  SearchServicesBloc(this._repository) : super(const SearchServicesState()) {
    on<SearchServicesRequested>(_onRequested);
    on<SearchServicesNextPageRequested>(_onNextPageRequested);
  }

  Future<void> _onRequested(
    SearchServicesRequested event,
    Emitter<SearchServicesState> emit,
  ) async {
    emit(
      SearchServicesState(
        status: SearchServicesStatus.loading,
        query: event.query,
      ),
    );

    try {
      final page = await _repository.searchServices(q: event.query);
      emit(
        SearchServicesState(
          status: SearchServicesStatus.success,
          services: page.items,
          meta: page.meta,
          query: event.query,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchServicesStatus.failure,
          message: _messageOf(e),
        ),
      );
    }
  }

  Future<void> _onNextPageRequested(
    SearchServicesNextPageRequested event,
    Emitter<SearchServicesState> emit,
  ) async {
    if (state.isLoadingMore ||
        !state.hasMore ||
        state.status != SearchServicesStatus.success) {
      return;
    }

    // Clear the last load-more error so it isn't reported again.
    emit(state.copyWith(isLoadingMore: true, message: ''));

    try {
      final page = await _repository.searchServices(
        q: state.query,
        page: state.meta.page + 1,
      );
      emit(
        state.copyWith(
          services: [...state.services, ...page.items],
          meta: page.meta,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      // Keep the loaded pages on screen and surface the message inline.
      emit(state.copyWith(isLoadingMore: false, message: _messageOf(e)));
    }
  }

  String _messageOf(Object error) =>
      error is ApiException ? error.message : error.toString();
}
