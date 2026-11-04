import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:noq/features/categories/data/category_model.dart';
import 'package:noq/features/categories/presentation/widgets/category_card.dart';

/// Placeholder grid shaped like the categories list while the first page loads.
class CategoriesLoadingWidget extends StatelessWidget {
  const CategoriesLoadingWidget({super.key});

  static const _placeholder = CategoryModel(
    id: '',
    name: 'Category',
    description: 'Category description',
    imageUrl: null,
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
        child: CategoryGrid(items: List.filled(10, _placeholder)),
      ),
    );
  }
}
