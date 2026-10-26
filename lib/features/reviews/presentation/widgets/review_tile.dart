import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/core/utils/date_time_utils.dart';
import 'package:noq/features/reviews/data/review_model.dart';

/// One row of the full reviews list.
class ReviewTile extends StatelessWidget {
  final ReviewModel review;

  const ReviewTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final createdAt = review.createdAt;
    final comment = review.comment;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Avatar(name: review.reviewer.name, url: review.reviewer.photoUrl),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Already shortened by the server ("Sarah J.") — print as-is.
                  Text(
                    review.reviewer.name,
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
        // Star-only reviews have no comment — draw just the name and stars.
        if (comment != null && comment.isNotEmpty) ...[
          SizedBox(height: 1.h),
          Text(comment, style: textTheme.bodyMedium),
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
