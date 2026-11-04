import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/core/services/recent_searches_service.dart';
import 'package:noq/features/search/bloc/search_event.dart';
import 'package:noq/features/search/bloc/search_state.dart';
import 'package:noq/features/search/repository/search_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  static const debounceDuration = Duration(milliseconds: 300);

  final SearchRepository _repository;
  final RecentSearchesService _recentSearches;

  SearchBloc(this._repository, this._recentSearches)
    : super(const SearchState()) {
    on<SearchStarted>(_onStarted);
    // restartable: a new input cancels the previous one's pending debounce
    // or in-flight request, so only the latest input can update the state.
    on<SearchInputEvent>(_onInput, transformer: restartable());
    on<RecentSearchRemoved>(_onRecentSearchRemoved);
    on<RecentSearchesCleared>(_onRecentSearchesCleared);
    on<SearchFavoriteChanged>(_onFavoriteChanged);
  }

  void _onFavoriteChanged(
    SearchFavoriteChanged event,
    Emitter<SearchState> emit,
  ) {
    final result = state.result;
    if (result == null) return;
    emit(
      state.copyWith(
        result: result.withFavorite(event.businessId, event.isFavorited),
      ),
    );
  }

  Future<void> _onStarted(
    SearchStarted event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      state.copyWith(
        recentSearches: await _recentSearches.getAll(),
        quickFiltersStatus: QuickFiltersStatus.loading,
      ),
    );

    try {
      final filters = await _repository.getQuickFilters();
      emit(
        state.copyWith(
          quickFilters: filters,
          quickFiltersStatus: QuickFiltersStatus.success,
        ),
      );
    } catch (_) {
      // The chips row is optional; the screen just hides it.
      emit(state.copyWith(quickFiltersStatus: QuickFiltersStatus.failure));
    }
  }

  Future<void> _onInput(
    SearchInputEvent event,
    Emitter<SearchState> emit,
  ) async {
    switch (event) {
      case SearchQueryChanged(:final query):
        final q = query.trim();
        if (q.length < 2) return _emitIdle(q, emit);
        // Already showing (or fetching) this exact query, e.g. the box was
        // submitted before the debounce ran out.
        if (q == state.query && state.status != SearchStatus.failure) return;

        await Future<void>.delayed(debounceDuration);
        // Cancelled while waiting: a newer input has taken over.
        if (emit.isDone) return;
        await _search(q, emit);

      case SearchSubmitted(:final query):
        final q = query.trim();
        if (q.length < 2) return _emitIdle(q, emit);
        emit(state.copyWith(recentSearches: await _recentSearches.add(q)));
        if (q == state.query && state.status == SearchStatus.success) return;
        await _search(q, emit);

      case SearchCleared():
        _emitIdle('', emit);
    }
  }

  Future<void> _search(String q, Emitter<SearchState> emit) async {
    emit(state.copyWith(query: q, status: SearchStatus.loading, message: ''));

    try {
      final result = await _repository.search(q);
      // A reply for an older query must never overwrite the current one.
      if (result.query != state.query) return;
      // All-zero groups are a normal "no results", not a failure.
      emit(state.copyWith(status: SearchStatus.success, result: result));
    } on ApiException catch (e) {
      if (e.code == 'VALIDATION_ERROR') {
        // Only possible if the length rules above drift from the server's;
        // treat it as "nothing to search" rather than showing an error.
        _emitIdle(q, emit);
      } else {
        emit(state.copyWith(status: SearchStatus.failure, message: e.message));
      }
    } catch (e) {
      emit(state.copyWith(status: SearchStatus.failure, message: e.toString()));
    }
  }

  void _emitIdle(String q, Emitter<SearchState> emit) {
    emit(
      state.copyWith(
        query: q,
        status: SearchStatus.initial,
        clearResult: true,
        message: '',
      ),
    );
  }

  Future<void> _onRecentSearchRemoved(
    RecentSearchRemoved event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      state.copyWith(recentSearches: await _recentSearches.remove(event.query)),
    );
  }

  Future<void> _onRecentSearchesCleared(
    RecentSearchesCleared event,
    Emitter<SearchState> emit,
  ) async {
    await _recentSearches.clear();
    emit(state.copyWith(recentSearches: const []));
  }
}
