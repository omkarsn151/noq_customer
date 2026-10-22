import 'package:equatable/equatable.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/features/categories/data/category_model.dart';

enum CategoriesStatus { initial, loading, success, failure }

class CategoriesState extends Equatable {
  final CategoriesStatus status;
  final List<CategoryModel> categories;
  final PageMeta meta;

  /// True while the next page is being appended.
  final bool isLoadingMore;
  final String message;

  const CategoriesState({
    this.status = CategoriesStatus.initial,
    this.categories = const [],
    this.meta = const PageMeta.empty(),
    this.isLoadingMore = false,
    this.message = '',
  });

  bool get hasMore => meta.hasNextPage;

  CategoriesState copyWith({
    CategoriesStatus? status,
    List<CategoryModel>? categories,
    PageMeta? meta,
    bool? isLoadingMore,
    String? message,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      meta: meta ?? this.meta,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    categories,
    // PageMeta is a plain model, so compare the fields the UI depends on.
    meta.page,
    meta.totalPages,
    meta.totalItems,
    isLoadingMore,
    message,
  ];
}
