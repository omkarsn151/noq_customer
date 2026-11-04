import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/reviews/data/review_model.dart';
import 'package:noq/features/reviews/presentation/widgets/review_tile.dart';

/// Placeholder review rows shown while the first page of reviews loads.
class ReviewsLoadingWidget extends StatelessWidget {
  const ReviewsLoadingWidget({super.key});

  static final _placeholder = ReviewModel(
    id: '',
    reviewer: const ReviewerModel(name: 'Reviewer name', photoUrl: null),
    rating: 5,
    comment:
        'Review comment placeholder text that runs across a couple of lines '
        'like a real review would.',
    createdAt: DateTime(2000),
    updatedAt: null,
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 4.h),
        itemCount: 6,
        separatorBuilder: (_, _) => Padding(
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          child: const Divider(height: 1, color: AppColors.borderLight),
        ),
        itemBuilder: (_, _) => ReviewTile(review: _placeholder),
      ),
    );
  }
}
