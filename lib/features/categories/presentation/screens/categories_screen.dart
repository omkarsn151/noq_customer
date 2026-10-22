import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/categories/bloc/categories_bloc.dart';
import 'package:noq/features/categories/bloc/categories_event.dart';
import 'package:noq/features/categories/bloc/categories_state.dart';
import 'package:noq/features/categories/presentation/widgets/category_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  /// Distance from the bottom, in pixels, at which the next page is fetched.
  static const double _loadMoreThreshold = 300;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<CategoriesBloc>().add(
      const CategoriesRequested(refresh: true),
    );
  }

  /// Requests the next page once the grid is scrolled near its end.
  bool _onScroll(CategoriesState state, ScrollNotification notification) {
    final position = notification.metrics;
    if (position.axis != Axis.vertical) return false;

    if (state.hasMore &&
        !state.isLoadingMore &&
        position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      context.read<CategoriesBloc>().add(const CategoriesNextPageRequested());
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Categories'),
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          switch (state.status) {
            case CategoriesStatus.initial:
            case CategoriesStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case CategoriesStatus.failure:
              return _CategoriesMessage(message: state.message, onRetry: _load);
            case CategoriesStatus.success:
              if (state.categories.isEmpty) {
                return _CategoriesMessage(
                  message: 'No categories yet',
                  onRetry: _load,
                );
              }
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async => _load(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) =>
                      _onScroll(state, notification),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
                    child: Column(
                      children: [
                        CategoryGrid(items: state.categories),
                        if (state.isLoadingMore)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}

class _CategoriesMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CategoriesMessage({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    // Kept scrollable so pull-to-refresh still works on an empty or failed list.
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => onRetry(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          SizedBox(height: 1.5.h),
          Center(
            child: TextButton(onPressed: onRetry, child: const Text('Retry')),
          ),
        ],
      ),
    );
  }
}
