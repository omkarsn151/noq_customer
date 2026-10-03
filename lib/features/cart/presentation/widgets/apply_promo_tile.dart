import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/promo/presentation/widgets/promo_code_bottom_sheet.dart';

class ApplyPromoTile extends StatelessWidget {
  const ApplyPromoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => PromoCodeBottomSheet.show(context),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        decoration: const BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Apply Promo',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: AppColors.primary),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18.sp,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
