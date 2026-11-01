import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/favorites/bloc/favorite_bloc.dart';
import 'package:noq/features/favorites/bloc/favorite_event.dart';
import 'package:noq/features/favorites/bloc/favorites_list_bloc.dart';
import 'package:noq/features/favorites/bloc/favorites_list_event.dart';
import 'package:noq/features/favorites/bloc/favorites_list_state.dart';
import 'package:noq/features/favorites/presentation/favorite_change_listener.dart';
import 'package:noq/features/favorites/repository/favorites_repository.dart';
import 'package:noq/features/home/presentation/widgets/business_card_widget.dart';

/// Owns its [FavoritesListBloc] rather than sharing an app-wide one, so the
/// list never outlives the session it was loaded for.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesListBloc>(
      create: (_) =>
          FavoritesListBloc(FavoritesRepository())
            ..add(const FavoritesListRequested()),
      child: const _FavoritesView(),
    );
  }
}

class _FavoritesView extends StatelessWidget {
  /// Distance from the bottom, in pixels, at which the next page is fetched.
  static const double _loadMoreThreshold = 300;

  const _FavoritesView();

  void _load(BuildContext context) {
    context.read<FavoritesListBloc>().add(const FavoritesListRequested());
  }

  /// Requests the next page once the list is scrolled near its end.
  bool _onScroll(
    BuildContext context,
    FavoritesListState state,
    ScrollNotification notification,
  ) {
    final position = notification.metrics;
    if (position.axis != Axis.vertical) return false;

    if (state.hasMore &&
        !state.isLoadingMore &&
        position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      context.read<FavoritesListBloc>().add(
        const FavoritesListNextPageRequested(),
      );
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'My Favourites'),
      body: FavoriteChangeListener(
        // Not limited to listed shops: one saved again from the details
        // screen has already left the list and has to come back.
        isRelevant: (_) => true,
        onChanged: (id, isFavorited) => context.read<FavoritesListBloc>().add(
          FavoritesListItemChanged(businessId: id, isFavorited: isFavorited),
        ),
        child: BlocBuilder<FavoritesListBloc, FavoritesListState>(
          builder: (context, state) {
            switch (state.status) {
              case FavoritesListStatus.initial:
              case FavoritesListStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case FavoritesListStatus.failure:
                return _FavoritesMessage(
                  message: state.message,
                  onRefresh: () => _load(context),
                  showRetry: true,
                );
              case FavoritesListStatus.success:
                if (state.businesses.isEmpty) {
                  return _FavoritesMessage(
                    message: 'No favourites yet',
                    icon: Icons.favorite_border_rounded,
                    onRefresh: () => _load(context),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async => _load(context),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) =>
                        _onScroll(context, state, notification),
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount:
                          state.businesses.length +
                          (state.isLoadingMore ? 1 : 0),
                      separatorBuilder: (_, _) => SizedBox(height: 2.h),
                      itemBuilder: (context, index) {
                        if (index == state.businesses.length) {
                          return Padding(
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
                          isFavorite: true,
                          onFavoriteTap: () => context.read<FavoriteBloc>().add(
                            FavoriteToggled(
                              businessId: item.id,
                              isFavorited: true,
                            ),
                          ),
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
      ),
    );
  }
}

class _FavoritesMessage extends StatelessWidget {
  final String message;
  final IconData? icon;
  final VoidCallback onRefresh;
  final bool showRetry;

  const _FavoritesMessage({
    required this.message,
    required this.onRefresh,
    this.icon,
    this.showRetry = false,
  });

  @override
  Widget build(BuildContext context) {
    // Kept scrollable so pull-to-refresh still works on an empty or failed list.
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => onRefresh(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 20.h),
          if (icon != null) ...[
            Icon(icon, size: 34.sp, color: AppColors.textSecondary),
            SizedBox(height: 1.5.h),
          ],
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
          if (showRetry) ...[
            SizedBox(height: 1.5.h),
            Center(
              child: TextButton(
                onPressed: onRefresh,
                child: const Text('Retry'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
