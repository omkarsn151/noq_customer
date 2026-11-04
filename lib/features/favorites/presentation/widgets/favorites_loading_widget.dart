import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:noq/features/home/presentation/widgets/business_card_widget.dart';

/// Placeholder favourite shop cards shown while the list's first page loads.
class FavoritesLoadingWidget extends StatelessWidget {
  const FavoritesLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (_, _) => SizedBox(height: 2.h),
        itemBuilder: (_, _) => const BusinessCardWidget(
          name: 'Business name placeholder',
          services: 'Service one, Service two',
          priceRange: '₹000 - ₹000',
          rating: 4.5,
          totalReviews: 10,
          address: 'Area, City',
          distance: '0.0 km',
          waitMinutes: 10,
          isFavorite: true,
        ),
      ),
    );
  }
}
