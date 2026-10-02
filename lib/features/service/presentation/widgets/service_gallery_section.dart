import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_assets.dart';

const _galleryImages = [
  AppAssets.category1,
  AppAssets.category2,
  AppAssets.category3,
  AppAssets.category4,
  AppAssets.specialOffer1,
  AppAssets.specialOffer2,
];

class ServiceGallerySection extends StatelessWidget {
  const ServiceGallerySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gallery', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 1.5.h),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _galleryImages.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2.w,
              crossAxisSpacing: 2.w,
            ),
            itemBuilder: (context, index) => ClipRRect(
              borderRadius: BorderRadius.circular(12.sp),
              child: Image.asset(_galleryImages[index], fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
