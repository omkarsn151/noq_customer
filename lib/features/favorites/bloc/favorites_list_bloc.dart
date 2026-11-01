import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/favorites/bloc/favorites_list_event.dart';
import 'package:noq/features/favorites/bloc/favorites_list_state.dart';
import 'package:noq/features/favorites/repository/favorites_repository.dart';

class FavoritesListBloc extends Bloc<FavoritesListEvent, FavoritesListState> {
  final FavoritesRepository _repository;

  FavoritesListBloc(this._repository) : super(const FavoritesListState()) {
    on<FavoritesListRequested>(_onRequested);
    on<FavoritesListNextPageRequested>(_onNextPageRequested);
    on<FavoritesListItemChanged>(_onItemChanged);
  }

  Future<void> _onRequested(
    FavoritesListRequested event,
    Emitter<FavoritesListState> emit,
  ) async {
    emit(const FavoritesListState(status: FavoritesListStatus.loading));

    try {
      final page = await _repository.getFavorites();
      emit(
        FavoritesListState(
          status: FavoritesListStatus.success,
          businesses: page.items,
          meta: page.meta,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FavoritesListStatus.failure,
          message: _messageOf(e),
        ),
      );
    }
  }

  Future<void> _onNextPageRequested(
    FavoritesListNextPageRequested event,
    Emitter<FavoritesListState> emit,
  ) async {
    if (state.isLoadingMore ||
        !state.hasMore ||
        state.status != FavoritesListStatus.success) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    try {
      // Worked out from the row count, not meta.page: every removed row moves
      // the later ones up a page, and those would otherwise be skipped.
      final page = await _repository.getFavorites(
        page:
            state.businesses.length ~/ FavoritesRepository.defaultPageSize + 1,
      );
      final loadedIds = state.businesses.map((item) => item.id).toSet();
      emit(
        state.copyWith(
          businesses: [
            ...state.businesses,
            ...page.items.where((item) => !loadedIds.contains(item.id)),
          ],
          meta: page.meta,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      // Keep the loaded pages on screen.
      emit(state.copyWith(isLoadingMore: false, message: _messageOf(e)));
    }
  }

  void _onItemChanged(
    FavoritesListItemChanged event,
    Emitter<FavoritesListState> emit,
  ) {
    final isListed = state.businesses.any(
      (item) => item.id == event.businessId,
    );

    if (event.isFavorited) {
      // Saved again from the details screen after its row was dropped.
      if (!isListed) add(const FavoritesListRequested());
      return;
    }

    if (!isListed) return;
    final remaining = state.businesses
        .where((item) => item.id != event.businessId)
        .toList();
    emit(state.copyWith(businesses: remaining));

    // An empty list can't be scrolled to fetch what's left.
    if (remaining.isEmpty && state.hasMore) {
      add(const FavoritesListRequested());
    }
  }

  String _messageOf(Object error) =>
      error is ApiException ? error.message : error.toString();
}
