import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';

class BusinessHeaderSection extends StatelessWidget {
  /// Null when the shop has no hero picture.
  final String? heroUrl;

  final bool isFavorited;

  const BusinessHeaderSection({
    super.key,
    required this.heroUrl,
    required this.isFavorited,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.sp),
            bottomRight: Radius.circular(25.sp),
          ),
          child: _buildImage(),
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
              _CircleOverlayButton(
                icon: isFavorited
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                iconColor: isFavorited ? AppColors.error : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    Widget placeholder() => Container(
      width: double.infinity,
      height: 30.h,
      color: AppColors.borderLight,
      child: Icon(
        Icons.storefront_outlined,
        size: 36.sp,
        color: AppColors.textSecondary,
      ),
    );

    final url = heroUrl;
    if (url == null) return placeholder();
    return Image.network(
      url,
      width: double.infinity,
      height: 30.h,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => placeholder(),
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
