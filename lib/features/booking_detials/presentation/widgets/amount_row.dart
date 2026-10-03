import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';

class AmountRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool emphasised;

  const AmountRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.emphasised = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: emphasised
                ? textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)
                : textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: emphasised
                ? textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  )
                : textTheme.bodySmall?.copyWith(
                    color: valueColor ?? AppColors.textPrimary,
                  ),
          ),
        ],
      ),
    );
  }
}
