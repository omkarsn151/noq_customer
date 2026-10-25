import 'package:equatable/equatable.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/features/business_list/data/business_list_model.dart';

enum BusinessListStatus { initial, loading, success, failure }

class BusinessListState extends Equatable {
  final BusinessListStatus status;
  final List<BusinessListModel> businesses;
  final PageMeta meta;

  /// True while the next page is being appended.
  final bool isLoadingMore;
  final String message;

  final String categoryId;

  /// Position the first page was fetched with, reused for later pages so the
  /// ordering stays consistent. Null when location was unavailable.
  final double? lat;
  final double? lng;

  const BusinessListState({
    this.status = BusinessListStatus.initial,
    this.businesses = const [],
    this.meta = const PageMeta.empty(),
    this.isLoadingMore = false,
    this.message = '',
    this.categoryId = '',
    this.lat,
    this.lng,
  });

  bool get hasMore => meta.hasNextPage;

  BusinessListState copyWith({
    BusinessListStatus? status,
    List<BusinessListModel>? businesses,
    PageMeta? meta,
    bool? isLoadingMore,
    String? message,
  }) {
    return BusinessListState(
      status: status ?? this.status,
      businesses: businesses ?? this.businesses,
      meta: meta ?? this.meta,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      message: message ?? this.message,
      categoryId: categoryId,
      lat: lat,
      lng: lng,
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
    categoryId,
    lat,
    lng,
  ];
}
