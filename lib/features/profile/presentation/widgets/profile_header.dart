import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 8.w,
            backgroundColor: AppColors.primary,
            child: Icon(
              Icons.person_outline_rounded,
              size: 22.sp,
              color: AppColors.background,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'johndoe@gmail.com',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Icon(
              Icons.edit_outlined,
              size: 18.sp,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
