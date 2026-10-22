import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/categories/bloc/categories_event.dart';
import 'package:noq/features/categories/bloc/categories_state.dart';
import 'package:noq/features/categories/repository/categories_repository.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoriesRepository _repository;

  CategoriesBloc(this._repository) : super(const CategoriesState()) {
    on<CategoriesRequested>(_onCategoriesRequested);
    on<CategoriesNextPageRequested>(_onNextPageRequested);
  }

  Future<void> _onCategoriesRequested(
    CategoriesRequested event,
    Emitter<CategoriesState> emit,
  ) async {
    if (!event.refresh &&
        (state.status == CategoriesStatus.success ||
            state.status == CategoriesStatus.loading)) {
      return;
    }

    emit(state.copyWith(status: CategoriesStatus.loading, message: ''));

    try {
      final page = await _repository.getCategories();
      emit(
        CategoriesState(
          status: CategoriesStatus.success,
          categories: page.items,
          meta: page.meta,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CategoriesStatus.failure,
          message: _messageOf(e),
        ),
      );
    }
  }

  Future<void> _onNextPageRequested(
    CategoriesNextPageRequested event,
    Emitter<CategoriesState> emit,
  ) async {
    if (state.isLoadingMore ||
        !state.hasMore ||
        state.status != CategoriesStatus.success) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    try {
      final page = await _repository.getCategories(page: state.meta.page + 1);
      emit(
        state.copyWith(
          categories: [...state.categories, ...page.items],
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
