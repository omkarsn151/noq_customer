import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';

class BusinessInfoSection extends StatelessWidget {
  const BusinessInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Reliance & Elegance Studio',
                  style: textTheme.displayLarge,
                ),
              ),
              SizedBox(width: 2.w),

              const _CircleIconButton(icon: Icons.call_rounded),
              SizedBox(width: 2.w),
              const _CircleIconButton(icon: Icons.chat_bubble_outline_rounded),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Haircut, Facial, Spa',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const _DetailsButton(),
            ],
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              const _Pill(
                icon: Icons.star_rounded,
                iconColor: Colors.amber,
                label: '4.8 (230)',
              ),
              SizedBox(width: 2.w),
              const _Pill(
                icon: Icons.access_time_rounded,
                iconColor: AppColors.primary,
                label: '15 MIN WAIT',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;

  const _CircleIconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(2.4.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Icon(icon, size: 16.sp, color: AppColors.primary),
      ),
    );
  }
}

class _DetailsButton extends StatelessWidget {
  const _DetailsButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.sp),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 14.sp,
            color: AppColors.textPrimary,
          ),
          SizedBox(width: 1.w),
          Text('Details', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const _Pill({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20.sp),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: iconColor),
          SizedBox(width: 1.w),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
