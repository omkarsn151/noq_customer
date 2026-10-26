import 'package:equatable/equatable.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/features/reviews/data/review_model.dart';

/// [notFound]: the shop is not public — leave the screen, do not retry.
enum ReviewsStatus { initial, loading, success, failure, notFound }

class ReviewsState extends Equatable {
  final ReviewsStatus status;
  final List<ReviewModel> reviews;
  final PageMeta meta;

  /// True while the next page is being appended.
  final bool isLoadingMore;
  final String message;

  final String businessId;

  const ReviewsState({
    this.status = ReviewsStatus.initial,
    this.reviews = const [],
    this.meta = const PageMeta.empty(),
    this.isLoadingMore = false,
    this.message = '',
    this.businessId = '',
  });

  bool get hasMore => meta.hasNextPage;

  ReviewsState copyWith({
    ReviewsStatus? status,
    List<ReviewModel>? reviews,
    PageMeta? meta,
    bool? isLoadingMore,
    String? message,
  }) {
    return ReviewsState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      meta: meta ?? this.meta,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      message: message ?? this.message,
      businessId: businessId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    reviews,
    // PageMeta is a plain model, so compare the fields the UI depends on.
    meta.page,
    meta.totalPages,
    meta.totalItems,
    isLoadingMore,
    message,
    businessId,
  ];
}
