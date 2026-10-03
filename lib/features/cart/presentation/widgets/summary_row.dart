import 'package:flutter/material.dart';
import 'package:noq/core/utils/app_colors.dart';

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  /// Overrides the default value colour; used to paint a live discount green.
  final Color? valueColor;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: textTheme.labelLarge?.copyWith(
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
