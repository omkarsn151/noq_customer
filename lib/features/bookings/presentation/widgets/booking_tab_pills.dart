import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/bookings/data/booking_tab.dart';

/// The Upcoming / Past / Cancelled filter row. Stays interactive in every
/// screen state so a failed tab can be escaped.
class BookingTabPills extends StatelessWidget {
  final BookingTab selected;
  final ValueChanged<BookingTab> onSelected;

  const BookingTabPills({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final tab in BookingTab.values) ...[
          if (tab != BookingTab.values.first) SizedBox(width: 2.w),
          _TabPill(
            label: tab.label,
            isSelected: tab == selected,
            onTap: () => onSelected(tab),
          ),
        ],
      ],
    );
  }
}

class _TabPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.pink,
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
