import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/reviews/bloc/reviews_bloc.dart';
import 'package:noq/features/reviews/bloc/reviews_event.dart';
import 'package:noq/features/reviews/bloc/reviews_state.dart';
import 'package:noq/features/reviews/presentation/widgets/review_tile.dart';

class ReviewsScreen extends StatefulWidget {
  final String businessId;

  const ReviewsScreen({super.key, required this.businessId});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  /// Distance from the bottom, in pixels, at which the next page is fetched.
  static const double _loadMoreThreshold = 300;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<ReviewsBloc>().add(
      ReviewsRequested(businessId: widget.businessId),
    );
  }

  /// Requests the next page once the list is scrolled near its end.
  bool _onScroll(ReviewsState state, ScrollNotification notification) {
    final position = notification.metrics;
    if (position.axis != Axis.vertical) return false;

    if (state.hasMore &&
        !state.isLoadingMore &&
        position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      context.read<ReviewsBloc>().add(const ReviewsNextPageRequested());
    }
    return false;
  }

  bool _isCurrent(ReviewsState state) => state.businessId == widget.businessId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewsBloc, ReviewsState>(
      listenWhen: (previous, current) =>
          _isCurrent(current) &&
          (current.status != previous.status ||
              current.message != previous.message),
      listener: (context, state) {
        if (state.status == ReviewsStatus.notFound) {
          // The shop is no longer public — leave instead of retrying.
          AppSnackbar.show(
            context,
            message: 'This business is no longer available.',
            type: AppSnackBarType.error,
          );
          context.pop();
        } else if (state.status == ReviewsStatus.success &&
            state.message.isNotEmpty) {
          // A later page failed; the loaded reviews stay on screen.
          AppSnackbar.show(
            context,
            message: state.message,
            type: AppSnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        final loaded =
            _isCurrent(state) && state.status == ReviewsStatus.success;
        final total = state.meta.totalItems;

        return Scaffold(
          appBar: AppAppBar(
            title: 'Reviews',
            subtitle: loaded
                ? '$total ${total == 1 ? 'review' : 'reviews'}'
                : null,
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(ReviewsState state) {
    // The bloc is app-wide, so ignore another shop's reviews.
    if (!_isCurrent(state)) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (state.status) {
      case ReviewsStatus.initial:
      case ReviewsStatus.loading:
      case ReviewsStatus.notFound:
        return const Center(child: CircularProgressIndicator());
      case ReviewsStatus.failure:
        return _ReviewsMessage(message: state.message, onRetry: _load);
      case ReviewsStatus.success:
        if (state.reviews.isEmpty) {
          return _ReviewsMessage(
            message: 'No reviews yet',
            onRetry: _load,
            showRetry: false,
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => _load(),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) => _onScroll(state, notification),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 4.h),
              itemCount: state.reviews.length + (state.isLoadingMore ? 1 : 0),
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                child: const Divider(height: 1, color: AppColors.borderLight),
              ),
              itemBuilder: (context, index) {
                if (index == state.reviews.length) {
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
                return ReviewTile(review: state.reviews[index]);
              },
            ),
          ),
        );
    }
  }
}

class _ReviewsMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool showRetry;

  const _ReviewsMessage({
    required this.message,
    required this.onRetry,
    this.showRetry = true,
  });

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
          if (showRetry) ...[
            SizedBox(height: 1.5.h),
            Center(
              child: TextButton(onPressed: onRetry, child: const Text('Retry')),
            ),
          ],
        ],
      ),
    );
  }
}
