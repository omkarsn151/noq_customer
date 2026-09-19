import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';

class _DummyService {
  final String discount;
  final String name;
  final String description;
  final String duration;
  final String? note;
  final String originalPrice;
  final String price;

  const _DummyService({
    required this.discount,
    required this.name,
    required this.description,
    required this.duration,
    this.note,
    required this.originalPrice,
    required this.price,
  });
}

class BusinessDetails extends StatelessWidget {
  const BusinessDetails({super.key});

  static const List<_DummyService> _services = [
    _DummyService(
      discount: '15% OFF',
      name: "Classic Men's Fade",
      description: 'Precision fade with razor finish',
      duration: '45 min',
      note: 'Includes wash',
      originalPrice: '₹55',
      price: '₹45',
    ),
    _DummyService(
      discount: '10% OFF',
      name: 'Beard Trim & Shape',
      description: 'Detailed beard sculpting and maintenance',
      duration: '30 min',
      originalPrice: '₹35',
      price: '₹31.50',
    ),
    _DummyService(
      discount: '20% OFF',
      name: 'Modern Pompadour',
      description: 'High volume style with sharp edges',
      duration: '50 min',
      originalPrice: '₹60',
      price: '₹48',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Radiance & Elegance Studio',
                          style: textTheme.headlineLarge,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      _DetailsButton(),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Haircuts, Make Up, Massage',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      _CircleIconButton(icon: Icons.call_rounded),
                      SizedBox(width: 2.w),
                      _CircleIconButton(
                        icon: Icons.chat_bubble_outline_rounded,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      _Pill(
                        icon: Icons.star_rounded,
                        iconColor: Colors.amber,
                        label: '4.7 (124)',
                      ),
                      SizedBox(width: 2.w),
                      _Pill(
                        icon: Icons.access_time_rounded,
                        iconColor: AppColors.primary,
                        label: '12 MIN WAIT',
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Popular Services',
                          style: textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        'See all',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  for (int i = 0; i < _services.length; i++) ...[
                    _ServiceTile(service: _services[i]),
                    if (i != _services.length - 1)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        child: Divider(height: 1, color: AppColors.borderLight),
                      ),
                  ],
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.sp),
            bottomRight: Radius.circular(24.sp),
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
              _CircleOverlayButton(icon: Icons.send_rounded),
              SizedBox(width: 2.w),
              _CircleOverlayButton(
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

class _CircleIconButton extends StatelessWidget {
  final IconData icon;

  const _CircleIconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.4.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Icon(icon, size: 16.sp, color: AppColors.primary),
    );
  }
}

class _DetailsButton extends StatelessWidget {
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
        color: AppColors.pink,
        borderRadius: BorderRadius.circular(20.sp),
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

class _ServiceTile extends StatelessWidget {
  final _DummyService service;

  const _ServiceTile({required this.service});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.sp),
              child: Image.asset(
                AppAssets.serviceThumbnail,
                width: 18.w,
                height: 25.w,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(service.discount, style: textTheme.bodySmall),
              Text(service.name, style: textTheme.bodyLarge),
              SizedBox(height: 0.4.h),
              Text(
                service.description,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pink,
                      borderRadius: BorderRadius.circular(20.sp),
                    ),
                    child: Text(service.duration, style: textTheme.bodySmall),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.5.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.sp),
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                    child: Text(
                      'ADD TO CART',
                      style: textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 2.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              service.originalPrice,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            Text(service.price, style: textTheme.bodyLarge),
          ],
        ),
      ],
    );
  }
}
