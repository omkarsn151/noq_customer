import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/business_details/data/business_details_model.dart';

class BusinessInfoSection extends StatelessWidget {
  final BusinessDetailsInfo business;
  final BusinessDetailsRating rating;
  final BusinessDetailsWait wait;
  final BusinessDetailsLocation location;

  const BusinessInfoSection({
    super.key,
    required this.business,
    required this.rating,
    required this.wait,
    required this.location,
  });

  Future<void> _open(BuildContext context, Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
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
    final directionsUrl = location.directionsUrl;
    // No coordinates means the address was never located — hide the map icon.
    final showDirections = location.latitude != null && directionsUrl != null;
    final waitMinutes = wait.minutes;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(business.name, style: textTheme.displayLarge),
              ),
              if (showDirections) ...[
                SizedBox(width: 2.w),
                _CircleIconButton(
                  icon: Icons.directions_rounded,
                  onTap: () => _open(context, Uri.parse(directionsUrl)),
                ),
              ],
              if (business.phone.isNotEmpty) ...[
                SizedBox(width: 2.w),
                _CircleIconButton(
                  icon: Icons.call_rounded,
                  onTap: () => _open(
                    context,
                    Uri(scheme: 'tel', path: business.phone),
                  ),
                ),
              ],
              SizedBox(width: 2.w),
              const _CircleIconButton(icon: Icons.chat_bubble_outline_rounded),
            ],
          ),
          SizedBox(width: 1.h),
          Text(
            business.servicesLabel,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              _Pill(
                icon: Icons.star_rounded,
                iconColor: Colors.amber,
                label: rating.label,
              ),
              if (waitMinutes != null) ...[
                SizedBox(width: 2.w),
                _Pill(
                  icon: Icons.access_time_rounded,
                  iconColor: AppColors.primary,
                  label: '$waitMinutes MIN WAIT',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap ?? () {},
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
