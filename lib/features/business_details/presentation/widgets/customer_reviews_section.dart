import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/core/utils/date_time_utils.dart';
import 'package:noq/features/business_details/data/business_details_model.dart';

class CustomerReviewsSection extends StatelessWidget {
  final String businessId;

  /// Preview only; the full list is a separate screen.
  final List<BusinessReviewModel> reviews;
  final BusinessDetailsRating rating;

  const CustomerReviewsSection({
    super.key,
    required this.businessId,
    required this.reviews,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;
    final total = rating.totalReviews;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Customer Reviews', style: textTheme.titleMedium),
          SizedBox(height: 0.5.h),
          Row(
            children: [
              Icon(Icons.star_rounded, size: 18.sp, color: Colors.amber),
              SizedBox(width: 1.w),
              Text(
                rating.isNew ? 'New' : rating.average.toStringAsFixed(1),
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 1.5.w),
              Text(
                '($total ${total == 1 ? 'rating' : 'ratings'})',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.5.h),
          for (final review in reviews) ...[
            _ReviewTile(review: review),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              child: const Divider(height: 1, color: AppColors.borderLight),
            ),
          ],
          Center(
            child: InkWell(
              onTap: () => context.push('/business-details/$businessId/reviews'),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.w),
                child: Text(
                  'Read all $total reviews',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final BusinessReviewModel review;

  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final createdAt = review.createdAt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Avatar(name: review.reviewerName, url: review.reviewerPhotoUrl),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.reviewerName,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (createdAt != null)
                    Text(
                      DateTimeUtils.timeAgo(createdAt),
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < 5; i++)
                  Icon(
                    i < review.rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 15.sp,
                    color: Colors.amber,
                  ),
              ],
            ),
          ],
        ),
        if (review.comment.isNotEmpty) ...[
          SizedBox(height: 1.h),
          Text(review.comment, style: textTheme.bodyMedium),
        ],
        SizedBox(height: 1.h),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final String? url;

  const _Avatar({required this.name, required this.url});

  @override
  Widget build(BuildContext context) {
    final size = 12.w;
    Widget initial() => CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.primaryLight,
      child: Text(
        name.isEmpty ? '?' : name[0].toUpperCase(),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    final photoUrl = url;
    if (photoUrl == null) return initial();
    return ClipOval(
      child: Image.network(
        photoUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => initial(),
      ),
    );
  }
}
