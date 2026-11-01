import 'package:equatable/equatable.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/features/business_list/data/business_list_model.dart';

enum FavoritesListStatus { initial, loading, success, failure }

class FavoritesListState extends Equatable {
  final FavoritesListStatus status;
  final List<BusinessListModel> businesses;
  final PageMeta meta;

  /// True while the next page is being appended.
  final bool isLoadingMore;
  final String message;

  const FavoritesListState({
    this.status = FavoritesListStatus.initial,
    this.businesses = const [],
    this.meta = const PageMeta.empty(),
    this.isLoadingMore = false,
    this.message = '',
  });

  bool get hasMore => meta.hasNextPage;

  FavoritesListState copyWith({
    FavoritesListStatus? status,
    List<BusinessListModel>? businesses,
    PageMeta? meta,
    bool? isLoadingMore,
    String? message,
  }) {
    return FavoritesListState(
      status: status ?? this.status,
      businesses: businesses ?? this.businesses,
      meta: meta ?? this.meta,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    businesses,
    // PageMeta is a plain model, so compare the fields the UI depends on.
    meta.page,
    meta.totalPages,
    meta.totalItems,
    isLoadingMore,
    message,
  ];
}
