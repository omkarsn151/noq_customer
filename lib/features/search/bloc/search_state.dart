import 'package:equatable/equatable.dart';
import 'package:noq/features/search/data/quick_filter_model.dart';
import 'package:noq/features/search/data/search_result_model.dart';

enum SearchStatus { initial, loading, success, failure }

enum QuickFiltersStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  /// The trimmed text the current results belong to.
  final String query;

  final SearchStatus status;

  /// Null until a search has succeeded, and again once the box is cleared.
  final SearchResultModel? result;
  final String message;

  final List<QuickFilterModel> quickFilters;

  /// Tracked apart from [status] so a quick-filter failure never blocks search.
  final QuickFiltersStatus quickFiltersStatus;

  final List<String> recentSearches;

  const SearchState({
    this.query = '',
    this.status = SearchStatus.initial,
    this.result,
    this.message = '',
    this.quickFilters = const [],
    this.quickFiltersStatus = QuickFiltersStatus.initial,
    this.recentSearches = const [],
  });

  /// Too short to search: show quick filters and recent searches instead of
  /// results.
  bool get isIdle => query.length < 2;

  SearchState copyWith({
    String? query,
    SearchStatus? status,
    SearchResultModel? result,
    bool clearResult = false,
    String? message,
    List<QuickFilterModel>? quickFilters,
    QuickFiltersStatus? quickFiltersStatus,
    List<String>? recentSearches,
  }) {
    return SearchState(
      query: query ?? this.query,
      status: status ?? this.status,
      result: clearResult ? null : (result ?? this.result),
      message: message ?? this.message,
      quickFilters: quickFilters ?? this.quickFilters,
      quickFiltersStatus: quickFiltersStatus ?? this.quickFiltersStatus,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }

  @override
  List<Object?> get props => [
    query,
    status,
    result,
    message,
    quickFilters,
    quickFiltersStatus,
    recentSearches,
  ];
}
