import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/business_details/data/business_details_model.dart';
import 'package:noq/features/service/data/service_details_model.dart';
import 'package:noq/features/service/presentation/widgets/service_bottom_bar.dart';
import 'package:noq/features/service/presentation/widgets/service_hero_section.dart';
import 'package:noq/features/service/presentation/widgets/service_info_section.dart';

/// Placeholder service page shaped like the loaded one while it loads.
class ServiceDetailsLoadingWidget extends StatelessWidget {
  const ServiceDetailsLoadingWidget({super.key});

  static const _placeholder = ServiceDetailsModel(
    id: '',
    name: 'Service name',
    description:
        'Service description placeholder text that runs across a few lines '
        'like a real description would.',
    durationMinutes: 30,
    pricing: ServicePricing(currencyCode: 'INR', price: '000.00'),
    heroUrl: null,
    gallery: [],
    isInCart: false,
    cartItemId: null,
    business: ServiceShopModel(id: '', name: 'Shop name placeholder'),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Skeletonizer(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const ServiceHeroSection(heroUrl: null),
                      SizedBox(height: 2.h),
                      const ServiceInfoSection(service: _placeholder),
                    ],
                  ),
                ),
              ),
              const ServiceBottomBar(service: _placeholder),
            ],
          ),
        ),
        // The page has no app bar, so keep a working back button over the
        // skeleton's one.
        Positioned(
          top: 6.h,
          left: 4.w,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(2.6.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
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
}
