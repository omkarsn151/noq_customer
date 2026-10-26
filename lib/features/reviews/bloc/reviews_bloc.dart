import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/reviews/bloc/reviews_event.dart';
import 'package:noq/features/reviews/bloc/reviews_state.dart';
import 'package:noq/features/reviews/repository/reviews_repository.dart';

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  final ReviewsRepository _repository;

  ReviewsBloc(this._repository) : super(const ReviewsState()) {
    on<ReviewsRequested>(_onReviewsRequested);
    on<ReviewsNextPageRequested>(_onNextPageRequested);
  }

  Future<void> _onReviewsRequested(
    ReviewsRequested event,
    Emitter<ReviewsState> emit,
  ) async {
    // Start from a clean state so another shop's reviews never flash up.
    emit(
      ReviewsState(
        status: ReviewsStatus.loading,
        businessId: event.businessId,
      ),
    );

    try {
      final page = await _repository.getReviews(businessId: event.businessId);
      emit(
        ReviewsState(
          status: ReviewsStatus.success,
          reviews: page.items,
          meta: page.meta,
          businessId: event.businessId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: _isNotFound(e)
              ? ReviewsStatus.notFound
              : ReviewsStatus.failure,
          message: _messageOf(e),
        ),
      );
    }
  }

  Future<void> _onNextPageRequested(
    ReviewsNextPageRequested event,
    Emitter<ReviewsState> emit,
  ) async {
    if (state.isLoadingMore ||
        !state.hasMore ||
        state.status != ReviewsStatus.success) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, message: ''));

    try {
      final page = await _repository.getReviews(
        businessId: state.businessId,
        page: state.meta.page + 1,
      );
      emit(
        state.copyWith(
          reviews: [...state.reviews, ...page.items],
          meta: page.meta,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      // Keep the loaded pages on screen and surface the message.
      emit(
        state.copyWith(
          status: _isNotFound(e) ? ReviewsStatus.notFound : null,
          isLoadingMore: false,
          message: _messageOf(e),
        ),
      );
    }
  }

  bool _isNotFound(Object error) =>
      error is ApiException && error.code == 'CUSTOMER_BUSINESS_NOT_FOUND';

  String _messageOf(Object error) =>
      error is ApiException ? error.message : error.toString();
}
