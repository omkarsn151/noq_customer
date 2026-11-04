import 'package:equatable/equatable.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/features/search/data/search_service_model.dart';

enum SearchServicesStatus { initial, loading, success, failure }

class SearchServicesState extends Equatable {
  final SearchServicesStatus status;
  final List<SearchServiceItem> services;
  final PageMeta meta;

  /// True while the next page is being appended.
  final bool isLoadingMore;
  final String message;

  /// The query the first page was fetched with, reused for later pages.
  final String query;

  const SearchServicesState({
    this.status = SearchServicesStatus.initial,
    this.services = const [],
    this.meta = const PageMeta.empty(),
    this.isLoadingMore = false,
    this.message = '',
    this.query = '',
  });

  bool get hasMore => meta.hasNextPage;

  SearchServicesState copyWith({
    SearchServicesStatus? status,
    List<SearchServiceItem>? services,
    PageMeta? meta,
    bool? isLoadingMore,
    String? message,
  }) {
    return SearchServicesState(
      status: status ?? this.status,
      services: services ?? this.services,
      meta: meta ?? this.meta,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      message: message ?? this.message,
      query: query,
    );
  }

  @override
  List<Object?> get props => [
    status,
    services,
    // PageMeta is a plain model, so compare the fields the UI depends on.
    meta.page,
    meta.totalPages,
    meta.totalItems,
    isLoadingMore,
    message,
    query,
  ];
}
