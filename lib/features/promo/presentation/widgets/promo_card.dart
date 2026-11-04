import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_button.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/promo/data/promo_model.dart';

class PromoCard extends StatelessWidget {
  final PromoOfferModel promo;
  final bool isSelected;
  final bool isApplying;
  final bool isRemoving;

  /// Null while any promo action is in flight.
  final VoidCallback? onApply;
  final VoidCallback? onRemove;

  const PromoCard({
    super.key,
    required this.promo,
    required this.isSelected,
    required this.isApplying,
    required this.isRemoving,
    required this.onApply,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final description = promo.description;
    final savings = promo.savingsLabel;

    final card = Container(
      padding: EdgeInsets.symmetric(horizontal: 3.6.w, vertical: 1.6.h),
      decoration: BoxDecoration(
        color: AppColors.textfieldFilledColor,
        borderRadius: BorderRadius.circular(3.08.w),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.borderLight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.3.w,
                    vertical: 0.4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(1.5.w),
                    border: Border.all(color: AppColors.pink),
                  ),
                  child: Text(
                    promo.code,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: 0.9.h),
                Text(
                  promo.title,
                  style: textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (description != null && description.isNotEmpty) ...[
                  SizedBox(height: 0.2.h),
                  Text(
                    description,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                SizedBox(height: 0.6.h),
                Text(
                  promo.discountLabel,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (savings != null) ...[
                  SizedBox(height: 0.2.h),
                  Text(
                    savings,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 3.6.w),
          _PromoCardAction(
            promo: promo,
            isSelected: isSelected,
            isApplying: isApplying,
            isRemoving: isRemoving,
            onApply: onApply,
            onRemove: onRemove,
          ),
        ],
      ),
    );

    // Greyed out rather than hidden: the customer should still see the offer
    // and the reason it does not apply.
    return promo.isApplicable ? card : Opacity(opacity: 0.5, child: card);
  }
}

class _PromoCardAction extends StatelessWidget {
  final PromoOfferModel promo;
  final bool isSelected;
  final bool isApplying;
  final bool isRemoving;
  final VoidCallback? onApply;
  final VoidCallback? onRemove;

  const _PromoCardAction({
    required this.promo,
    required this.isSelected,
    required this.isApplying,
    required this.isRemoving,
    required this.onApply,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    // A selected code stays removable even if the server has since turned it
    // unusable, so this check comes before the applicability one.
    if (isSelected) {
      return _RemoveAction(isRemoving: isRemoving, onRemove: onRemove);
    }

    if (!promo.isApplicable) {
      return SizedBox(
        width: 24.w,
        child: Text(
          promo.unavailableReason?.label ??
              PromoUnavailableReason.unknown.label,
          textAlign: TextAlign.end,
          style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
        ),
      );
    }

    return SizedBox(
      width: 22.w,
      height: 5.h,
      child: AppButton(
        label: 'Apply',
        isLoading: isApplying,
        onPressed: onApply,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _RemoveAction extends StatelessWidget {
  final bool isRemoving;
  final VoidCallback? onRemove;

  const _RemoveAction({required this.isRemoving, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 17.sp,
              color: AppColors.success,
            ),
            SizedBox(width: 1.w),
            Text(
              'Applied',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.8.h),
        InkWell(
          borderRadius: BorderRadius.circular(2.6.w),
          onTap: isRemoving ? null : onRemove,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.6.w),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: isRemoving
                ? SizedBox(
                    width: 15.sp,
                    height: 15.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: AppColors.primary,
                    ),
                  )
                : Text(
                    'Remove',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
