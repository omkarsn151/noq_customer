import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';

class _ReviewItem {
  final String avatar;
  final String name;
  final String timeAgo;
  final int rating;
  final String comment;
  final int helpfulCount;

  const _ReviewItem({
    required this.avatar,
    required this.name,
    required this.timeAgo,
    required this.rating,
    required this.comment,
    required this.helpfulCount,
  });
}

const _reviews = [
  _ReviewItem(
    avatar: AppAssets.category1,
    name: 'Sarah Jenkins',
    timeAgo: '2 days ago',
    rating: 4,
    comment:
        'Absolutely loved my experience here. The live wait time estimation was exactly accurate—I joined the queue from home and walked right into the chair. The staff is incredibly professional and the fade was top-notch. Highly recommend!',
    helpfulCount: 12,
  ),
  _ReviewItem(
    avatar: AppAssets.category2,
    name: 'Michael Chen',
    timeAgo: '1 week ago',
    rating: 3,
    comment:
        "Great service overall. The stylist really took the time to understand what I wanted. The only downside was parking in the area, but the app's wait time feature made it so I didn't have to sit in the lobby forever.",
    helpfulCount: 3,
  ),
];

class CustomerReviewsSection extends StatelessWidget {
  const CustomerReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
                '4.8',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 1.5.w),
              Text(
                '(124 ratings)',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.5.h),
          for (final review in _reviews) ...[
            _ReviewTile(review: review),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              child: const Divider(height: 1, color: AppColors.borderLight),
            ),
          ],
          Center(
            child: Text(
              'Read all 124 reviews',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final _ReviewItem review;

  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipOval(
              child: Image.asset(
                review.avatar,
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.name,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    review.timeAgo,
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
        SizedBox(height: 1.h),
        Text(review.comment, style: textTheme.bodyMedium),
        SizedBox(height: 1.h),
      ],
    );
  }
}
