import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';

class BusinessHeader extends StatelessWidget {
  final String name;
  final String distance;
  final String openTill;

  const BusinessHeader({
    super.key,
    required this.name,
    required this.distance,
    required this.openTill,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final captionStyle = textTheme.bodySmall?.copyWith(
      color: AppColors.textSecondary,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14.sp),
          child: Image.asset(
            AppAssets.businessThumbnail,
            width: 22.w,
            height: 22.w,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: textTheme.bodyLarge
              ),
              SizedBox(height: 0.8.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 0.5.h,
                children: [
                  _IconText(
                    icon: Icons.location_on_outlined,
                    text: distance,
                    style: captionStyle,
                  ),
                  _IconText(
                    icon: Icons.access_time_rounded,
                    text: openTill,
                    style: captionStyle,
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              InkWell(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Get Directions',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(
                      Icons.north_east_rounded,
                      size: 15.sp,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextStyle? style;

  const _IconText({required this.icon, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15.sp, color: AppColors.textSecondary),
        SizedBox(width: 0.5.w),
        Text(text, style: style),
      ],
    );
  }
}
