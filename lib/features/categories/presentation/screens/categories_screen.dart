import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/features/categories/presentation/widgets/category_card.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Categories'),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
        child: const CategoryGrid(items: categoryItems),
      ),
    );
  }
}
