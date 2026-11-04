import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:noq/features/service_list/data/service_list_model.dart';
import 'package:noq/features/service_list/presentation/widgets/service_category_section.dart';

/// Placeholder collapsed sections shown while the shop's sections load.
class ServiceListScreenLoadingWidget extends StatelessWidget {
  const ServiceListScreenLoadingWidget({super.key});

  static const _placeholder = ShopSectionModel(
    id: '',
    name: 'Section name',
    imageUrl: null,
    serviceCount: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        itemBuilder: (_, _) => ServiceCategorySection(
          businessId: '',
          section: _placeholder,
          services: null,
          onExpand: () {},
        ),
      ),
    );
  }
}
