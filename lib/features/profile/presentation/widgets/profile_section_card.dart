import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';

class ProfileMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final bool? showChevron;

  const ProfileMenuItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
    this.showChevron,
  });
}

class ProfileSectionCard extends StatelessWidget {
  final String title;
  final List<ProfileMenuItem> items;

  const ProfileSectionCard({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 0.5.h),
          for (int i = 0; i < items.length; i++) ...[
            _MenuRow(item: items[i]),
            if (i != items.length - 1)
              const Divider(height: 1, color: AppColors.borderLight),
          ],
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final ProfileMenuItem item;

  const _MenuRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.color ?? AppColors.textPrimary;

    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        child: Row(
          children: [
            Icon(item.icon, size: 18.sp, color: color),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                item.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: item.color != null
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ),
            if (item.showChevron != false)
              Icon(
                Icons.chevron_right_rounded,
                size: 18.sp,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
