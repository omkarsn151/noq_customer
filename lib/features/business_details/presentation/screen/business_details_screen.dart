import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/features/business_details/presentation/widgets/business_header_section.dart';
import 'package:noq/features/business_details/presentation/widgets/business_info_section.dart';
import 'package:noq/features/business_details/presentation/widgets/customer_reviews_section.dart';
import 'package:noq/features/business_details/presentation/widgets/popular_services_section.dart';

class BusinessDetailsScreen extends StatelessWidget {
  const BusinessDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const BusinessHeaderSection(),
            SizedBox(height: 2.h),
            const BusinessInfoSection(),
            SizedBox(height: 4.h),
            const PopularServicesSection(),
            SizedBox(height: 4.h),
            const CustomerReviewsSection(),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
