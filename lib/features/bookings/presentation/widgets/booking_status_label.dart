import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';

/// Icon + label pair for a booking's status. The API sends a free-form string,
/// so unknown values fall back to a neutral style rather than throwing.
class BookingStatusLabel extends StatelessWidget {
  final String status;

  const BookingStatusLabel({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = _styleFor(status);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(style.icon, size: 15.sp, color: style.color),
        SizedBox(width: 1.w),
        Text(
          style.label,
          style: textTheme.bodySmall?.copyWith(
            color: style.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  _StatusStyle _styleFor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return _StatusStyle(
          Icons.access_time_rounded,
          AppColors.primary,
          'Pending',
        );
      case 'confirmed':
        return _StatusStyle(
          Icons.check_circle_rounded,
          AppColors.success,
          'Confirmed',
        );
      case 'completed':
        return _StatusStyle(
          Icons.check_circle_rounded,
          AppColors.blue,
          'Completed',
        );
      case 'cancelled':
      case 'canceled':
        return _StatusStyle(
          Icons.cancel_rounded,
          AppColors.error,
          'Cancelled',
        );
      default:
        return _StatusStyle(
          Icons.info_outline_rounded,
          AppColors.textSecondary,
          _titleCase(status),
        );
    }
  }

  static String _titleCase(String value) {
    if (value.isEmpty) return 'Unknown';
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}

class _StatusStyle {
  final IconData icon;
  final Color color;
  final String label;

  const _StatusStyle(this.icon, this.color, this.label);
}
