import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/business_details/presentation/widgets/service_tile.dart';

const _services = [
  ServiceItem(
    name: 'Classic Haircut',
    description: 'Wash, cut and blow dry by our expert stylists.',
    durationMinutes: 30,
    price: 499,
    thumbnail: AppAssets.serviceThumbnail2,
  ),
  ServiceItem(
    name: 'Deep Cleansing Facial',
    description: 'Refreshing facial for glowing, healthy skin.',
    durationMinutes: 45,
    price: 899,
    thumbnail: AppAssets.serviceThumbnail3,
  ),
  ServiceItem(
    name: 'Relaxing Body Spa',
    description: 'Full body massage to relieve stress and tension.',
    durationMinutes: 60,
    price: 1499,
    thumbnail: AppAssets.serviceThumbnail4,
  ),
];

class PopularServicesSection extends StatelessWidget {
  const PopularServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Popular Services', style: textTheme.titleMedium),
              ),
              InkWell(
                onTap: () => context.push('/service-list'),
                child: Text(
                  'See all',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          for (int i = 0; i < _services.length; i++) ...[
            ServiceTile(service: _services[i]),
            if (i != _services.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                child: const Divider(height: 1, color: AppColors.borderLight),
              ),
          ],
        ],
      ),
    );
  }
}
