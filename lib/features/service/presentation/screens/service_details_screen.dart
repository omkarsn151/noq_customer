import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/features/service/presentation/widgets/service_bottom_bar.dart';
import 'package:noq/features/service/presentation/widgets/service_gallery_section.dart';
import 'package:noq/features/service/presentation/widgets/service_hero_section.dart';
import 'package:noq/features/service/presentation/widgets/service_info_section.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ServiceHeroSection(),
            SizedBox(height: 2.h),
            const ServiceInfoSection(),
            SizedBox(height: 3.h),
            const ServiceGallerySection(),
            SizedBox(height: 3.h),
          ],
        ),
      ),
      bottomNavigationBar: const ServiceBottomBar(),
    );
  }
}
