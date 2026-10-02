import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/features/home/presentation/widgets/home_app_bar.dart';
import 'package:noq/features/home/presentation/widgets/up_next_section.dart';
import 'package:noq/features/home/presentation/widgets/categories_section.dart';
import 'package:noq/features/home/presentation/widgets/special_offers_section.dart';
import 'package:noq/features/home/presentation/widgets/nearby_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HomeAppBar(),
            SizedBox(height: 2.h),
            const UpNextSection(),
            SizedBox(height: 3.h),
            const CategoriesSection(),
            SizedBox(height: 3.h),
            const SpecialOffersSection(),
            SizedBox(height: 3.h),
            const NearbySection(),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}
