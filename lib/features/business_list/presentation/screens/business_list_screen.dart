import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/business_list/bloc/business_list_bloc.dart';
import 'package:noq/features/business_list/bloc/business_list_event.dart';
import 'package:noq/features/business_list/bloc/business_list_state.dart';
import 'package:noq/features/home/presentation/widgets/business_card_widget.dart';

class BusinessListScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const BusinessListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<BusinessListScreen> createState() => _BusinessListScreenState();
}

class _BusinessListScreenState extends State<BusinessListScreen> {
  /// Distance from the bottom, in pixels, at which the next page is fetched.
  static const double _loadMoreThreshold = 300;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<BusinessListBloc>().add(
      BusinessListRequested(categoryId: widget.categoryId),
    );
  }

  /// Requests the next page once the list is scrolled near its end.
  bool _onScroll(BusinessListState state, ScrollNotification notification) {
    final position = notification.metrics;
    if (position.axis != Axis.vertical) return false;

    if (state.hasMore &&
        !state.isLoadingMore &&
        position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      context.read<BusinessListBloc>().add(
        const BusinessListNextPageRequested(),
      );
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: widget.categoryName),
      body: BlocBuilder<BusinessListBloc, BusinessListState>(
        builder: (context, state) {
          switch (state.status) {
            case BusinessListStatus.initial:
            case BusinessListStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case BusinessListStatus.failure:
              return _BusinessListMessage(
                message: state.message,
                onRetry: _load,
              );
            case BusinessListStatus.success:
              if (state.businesses.isEmpty) {
                return _BusinessListMessage(
                  message: 'No businesses in this category yet',
                  onRetry: _load,
                );
              }
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async => _load(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) =>
                      _onScroll(state, notification),
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount:
                        state.businesses.length + (state.isLoadingMore ? 1 : 0),
                    separatorBuilder: (_, _) => SizedBox(height: 2.h),
                    itemBuilder: (context, index) {
                      if (index == state.businesses.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }
                      final item = state.businesses[index];
                      return BusinessCardWidget(
                        imageUrl: item.thumbnailUrl,
                        name: item.name,
                        services: item.servicesLabel,
                        priceRange: item.pricing?.priceLabel,
                        rating: item.rating.average,
                        totalReviews: item.rating.totalReviews,
                        address: item.address,
                        distance: item.distanceLabel,
                        waitMinutes: item.waitMinutes,
                        isFavorite: item.isFavorited,
                        onTap: () =>
                            context.push('/business-details/${item.id}'),
                      );
                    },
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}

class _BusinessListMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _BusinessListMessage({required this.message, required this.onRetry});

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
