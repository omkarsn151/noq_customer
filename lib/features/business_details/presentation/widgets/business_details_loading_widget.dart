import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/business_details/data/business_details_model.dart';
import 'package:noq/features/business_details/presentation/widgets/business_header_section.dart';
import 'package:noq/features/business_details/presentation/widgets/business_info_section.dart';
import 'package:noq/features/business_details/presentation/widgets/popular_services_section.dart';

/// Placeholder shop page shaped like the loaded one while it loads.
class BusinessDetailsLoadingWidget extends StatelessWidget {
  const BusinessDetailsLoadingWidget({super.key});

  static const _info = BusinessDetailsInfo(
    name: 'Business name',
    heroUrl: null,
    thumbnailUrls: [],
    services: ['Service one', 'Service two', 'Service three'],
    phone: '',
    description: null,
  );

  static const _service = BusinessServiceModel(
    id: '',
    name: 'Service name placeholder',
    description: 'Service description placeholder text',
    durationMinutes: 30,
    pricing: ServicePricing(currencyCode: 'INR', price: '000.00'),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Skeletonizer(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                const BusinessHeaderSection(heroUrl: null, isFavorited: false),
                SizedBox(height: 2.h),
                const BusinessInfoSection(
                  business: _info,
                  rating: BusinessDetailsRating(average: 4.5, totalReviews: 10),
                  wait: BusinessDetailsWait(minutes: 10),
                  location: BusinessDetailsLocation(),
                ),
                SizedBox(height: 4.h),
                const PopularServicesSection(
                  businessId: '',
                  services: [_service, _service, _service],
                ),
              ],
            ),
          ),
        ),
        // The page has no app bar, so keep a working back button over the
        // skeleton's one.
        Positioned(
          top: 6.h,
          left: 4.w,
          child: InkWell(
            onTap: () => context.pop(),
            customBorder: const CircleBorder(),
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
