import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/booking_detials/presentation/widgets/details_card.dart';

class VerificationCodeCard extends StatelessWidget {
  final String code;

  const VerificationCodeCard({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTitle('Verification Code'),
          SizedBox(height: 0.6.h),
          Text(
            'Share this code with the business when you arrive to verify '
            'your booking.',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 1.5.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Text(
              code.isEmpty ? '--' : code,
              style: textTheme.headlineLarge?.copyWith(
                color: AppColors.primary,
                letterSpacing: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
