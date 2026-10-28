import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';

/// The shop strip. Each optional line is hidden when its value is null.
class BusinessHeader extends StatelessWidget {
  final String name;
  final String? thumbnailUrl;

  /// e.g. `1.2 Kms Away`.
  final String? distance;

  /// e.g. `Opens till 8 PM`.
  final String? openTill;

  /// The server's `directions_url` — never hand-build a Maps URL. Null when
  /// the shop has no map pin; Get Directions then shows a snackbar.
  final String? directionsUrl;
  final VoidCallback? onTap;

  const BusinessHeader({
    super.key,
    required this.name,
    this.thumbnailUrl,
    this.distance,
    this.openTill,
    this.directionsUrl,
    this.onTap,
  });

  Future<void> _openDirections(BuildContext context, String? url) async {
    if (url == null) {
      AppSnackbar.show(
        context,
        message: 'Location is not available for this shop.',
        type: AppSnackBarType.error,
      );
      return;
    }
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      AppSnackbar.show(
        context,
        message: 'Could not open this link.',
        type: AppSnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final captionStyle = textTheme.bodySmall?.copyWith(
      color: AppColors.textSecondary,
    );
    final placeholder = Image.asset(
      AppAssets.businessThumbnail,
      width: 22.w,
      height: 22.w,
      fit: BoxFit.cover,
    );

    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.sp),
            child: thumbnailUrl == null
                ? placeholder
                : Image.network(
                    thumbnailUrl!,
                    width: 22.w,
                    height: 22.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => placeholder,
                  ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: textTheme.bodyLarge),
                if (distance != null || openTill != null) ...[
                  SizedBox(height: 0.8.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 0.5.h,
                    children: [
                      if (distance != null)
                        _IconText(
                          icon: Icons.location_on_outlined,
                          text: distance!,
                          style: captionStyle,
                        ),
                      if (openTill != null)
                        _IconText(
                          icon: Icons.access_time_rounded,
                          text: openTill!,
                          style: captionStyle,
                        ),
                    ],
                  ),
                ],
                SizedBox(height: 1.h),
                InkWell(
                  onTap: () => _openDirections(context, directionsUrl),
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
      ),
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
