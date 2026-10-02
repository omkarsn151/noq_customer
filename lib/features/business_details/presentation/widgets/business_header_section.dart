import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';

class BusinessHeaderSection extends StatelessWidget {
  const BusinessHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.sp),
            bottomRight: Radius.circular(25.sp),
          ),
          child: Image.asset(
            AppAssets.businessThumbnail,
            width: double.infinity,
            height: 30.h,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 6.h,
          left: 4.w,
          child: _CircleOverlayButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        Positioned(
          top: 6.h,
          right: 4.w,
          child: Row(
            children: [
              const _CircleOverlayButton(icon: Icons.send_rounded),
              SizedBox(width: 2.w),
              const _CircleOverlayButton(
                icon: Icons.favorite_rounded,
                iconColor: AppColors.error,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircleOverlayButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _CircleOverlayButton({required this.icon, this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        padding: EdgeInsets.all(2.6.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: iconColor ?? AppColors.textPrimary,
        ),
      ),
    );
  }
}
