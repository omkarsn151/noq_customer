import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/common/app_search_field.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/favorites/presentation/favorite_change_listener.dart';
import 'package:noq/features/search/bloc/search_bloc.dart';
import 'package:noq/features/search/bloc/search_event.dart';
import 'package:noq/features/search/bloc/search_state.dart';
import 'package:noq/features/search/presentation/widgets/quick_filters_section.dart';
import 'package:noq/features/search/presentation/widgets/recent_searches_section.dart';
import 'package:noq/features/search/presentation/widgets/search_businesses_section.dart';
import 'package:noq/features/search/presentation/widgets/search_categories_section.dart';
import 'package:noq/features/search/presentation/widgets/search_loading_widget.dart';
import 'package:noq/features/search/presentation/widgets/search_services_section.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  /// The search API rejects longer queries.
  static const _maxQueryLength = 100;

  final _controller = TextEditingController();

  SearchBloc get _bloc => context.read<SearchBloc>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    _bloc.add(const SearchCleared());
  }

  void _searchRecent(String query) {
    _controller.value = TextEditingValue(
      text: query,
      selection: TextSelection.collapsed(offset: query.length),
    );
    FocusScope.of(context).unfocus();
    _bloc.add(SearchSubmitted(query));
  }

  /// Opening a result counts as using the search, so keep it in recents.
  void _rememberQuery() => _bloc.add(SearchSubmitted(_bloc.state.query));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.searchScreenBackground,
      appBar: const AppAppBar(title: 'Search'),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25.sp),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 2.5.h),
                // Rebuilt on every edit so the clear button tracks the text.
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) => AppSearchField(
                    controller: _controller,
                    hintText: 'Search clinics, barbers, DMV...',
                    maxLength: _maxQueryLength,
                    onChanged: (value) => _bloc.add(SearchQueryChanged(value)),
                    onSubmitted: (value) => _bloc.add(SearchSubmitted(value)),
                    onClear: _clear,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FavoriteChangeListener(
              isRelevant: (id) =>
                  _bloc.state.result?.businesses.items.any((b) => b.id == id) ??
                  false,
              onChanged: (id, isFavorited) => _bloc.add(
                SearchFavoriteChanged(businessId: id, isFavorited: isFavorited),
              ),
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) => state.isIdle
                    ? _IdleView(
                        state: state,
                        onRecentSelected: _searchRecent,
                        onRecentRemoved: (query) =>
                            _bloc.add(RecentSearchRemoved(query)),
                        onRecentCleared: () =>
                            _bloc.add(const RecentSearchesCleared()),
                      )
                    : _ResultsView(
                        state: state,
                        onResultSelected: _rememberQuery,
                        onRetry: () =>
                            _bloc.add(SearchQueryChanged(state.query)),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown until at least 2 characters are typed.
class _IdleView extends StatelessWidget {
  final SearchState state;
  final ValueChanged<String> onRecentSelected;
  final ValueChanged<String> onRecentRemoved;
  final VoidCallback onRecentCleared;

  const _IdleView({
    required this.state,
    required this.onRecentSelected,
    required this.onRecentRemoved,
    required this.onRecentCleared,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 2.5.h),
      children: [
        // Optional row: hidden while loading or if it failed.
        if (state.quickFiltersStatus == QuickFiltersStatus.success)
          Padding(
            padding: EdgeInsets.only(bottom: 3.h),
            child: QuickFiltersSection(filters: state.quickFilters),
          ),
        RecentSearchesSection(
          searches: state.recentSearches,
          onSelected: onRecentSelected,
          onRemoved: onRecentRemoved,
          onClear: onRecentCleared,
        ),
      ],
    );
  }
}

class _ResultsView extends StatelessWidget {
  final SearchState state;
  final VoidCallback onResultSelected;
  final VoidCallback onRetry;

  const _ResultsView({
    required this.state,
    required this.onResultSelected,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final result = state.result;

    switch (state.status) {
      case SearchStatus.loading:
        return const SearchLoadingWidget();
      case SearchStatus.failure:
        return _SearchMessage(
          message: state.message,
          action: TextButton(onPressed: onRetry, child: const Text('Retry')),
        );
      case SearchStatus.initial:
      case SearchStatus.success:
        // Initial here means the server rejected the query (VALIDATION_ERROR):
        // there's nothing to show, and it isn't an error for the customer.
        if (result == null) return const SizedBox.shrink();
    }

    if (result.isEmpty) {
      return _SearchMessage(message: 'No results for "${result.query}"');
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 0),
      children: [
        SearchCategoriesSection(
          group: result.categories,
          onSelected: onResultSelected,
        ),
        SearchBusinessesSection(
          group: result.businesses,
          query: result.query,
          onSelected: onResultSelected,
        ),
        SearchServicesSection(
          group: result.services,
          query: result.query,
          onSelected: onResultSelected,
        ),
      ],
    );
  }
}

class _SearchMessage extends StatelessWidget {
  final String message;
  final Widget? action;

  const _SearchMessage({required this.message, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 12.h, 8.w, 0),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          if (action != null) ...[SizedBox(height: 1.5.h), action!],
        ],
      ),
    );
  }
}
