import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';

class ServiceHeroSection extends StatelessWidget {
  /// Null when the service has no picture — a placeholder is shown.
  final String? heroUrl;

  const ServiceHeroSection({super.key, required this.heroUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.sp)),
          child: _buildImage(),
        ),
        Positioned(
          top: 6.h,
          left: 4.w,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(2.6.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 18.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    Widget placeholder() => Container(
      width: double.infinity,
      height: 38.h,
      color: AppColors.borderLight,
      child: Icon(
        Icons.content_cut_rounded,
        size: 40.sp,
        color: AppColors.textSecondary,
      ),
    );

    final url = heroUrl;
    if (url == null) return placeholder();
    return Image.network(
      url,
      width: double.infinity,
      height: 38.h,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => placeholder(),
    );
  }
}
