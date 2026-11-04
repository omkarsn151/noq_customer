import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:noq/features/business_details/data/business_details_model.dart';
import 'package:noq/features/search/data/search_service_model.dart';
import 'package:noq/features/search/presentation/widgets/search_service_tile.dart';

/// Placeholder rows shaped like service results while a search is running.
class SearchLoadingWidget extends StatelessWidget {
  const SearchLoadingWidget({super.key});

  static const _placeholder = SearchServiceItem(
    id: '',
    name: 'Service name placeholder',
    durationMinutes: 30,
    pricing: ServicePricing(currencyCode: 'INR', price: '000.00'),
    thumbnailUrl: null,
    business: SearchServiceBusiness(id: '', name: 'Shop name placeholder'),
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 0),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (_, _) => SizedBox(height: 3.h),
        itemBuilder: (_, _) => const SearchServiceTile(service: _placeholder),
      ),
    );
  }
}
