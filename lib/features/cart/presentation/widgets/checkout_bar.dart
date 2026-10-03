import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_button.dart';
import 'package:noq/core/utils/app_colors.dart';

class CheckoutBar extends StatelessWidget {
  final int servicesCount;
  final String totalPayable;
  final String businessId;

  const CheckoutBar({
    super.key,
    required this.servicesCount,
    required this.totalPayable,
    required this.businessId,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$servicesCount ${servicesCount == 1 ? 'Service' : 'Services'}',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '₹$totalPayable',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 40.w,
            height: 6.h,
            child: AppButton(
              label: 'Proceed To Pay',
              onPressed: () => context.push('/slots/$businessId'),
            ),
          ),
        ],
      ),
    );
  }
}
