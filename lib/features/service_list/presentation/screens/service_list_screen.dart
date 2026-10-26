import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/common/app_search_field.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/business_details/data/business_details_model.dart';
import 'package:noq/features/service_list/presentation/widgets/service_category_section.dart';

// Placeholder data until the All Services screen is wired to the API.
const _haircut = BusinessServiceModel(
  id: 'dummy-haircut',
  name: 'Classic Haircut',
  description: 'Wash, cut and blow dry by our expert stylists.',
  durationMinutes: 30,
  pricing: ServicePricing(currencyCode: 'INR', price: '499.00'),
);
const _facial = BusinessServiceModel(
  id: 'dummy-facial',
  name: 'Deep Cleansing Facial',
  description: 'Refreshing facial for glowing, healthy skin.',
  durationMinutes: 45,
  pricing: ServicePricing(currencyCode: 'INR', price: '899.00'),
);
const _spa = BusinessServiceModel(
  id: 'dummy-spa',
  name: 'Relaxing Body Spa',
  description: 'Full body massage to relieve stress and tension.',
  durationMinutes: 60,
  pricing: ServicePricing(currencyCode: 'INR', price: '1499.00'),
);

const _categories = <String, List<BusinessServiceModel>>{
  'Hair Cuts & Styling': [_haircut, _facial],
  'Beard Care': [_spa],
  'Shave & Grooming': [_haircut],
};

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setQuery(String value) => setState(() => _query = value.trim());

  @override
  Widget build(BuildContext context) {
    final searching = _query.isNotEmpty;
    final sections = <Widget>[];

    _categories.forEach((title, services) {
      final matches = services
          .where((s) => s.name.toLowerCase().contains(_query.toLowerCase()))
          .toList();
      if (matches.isEmpty) return;
      sections.add(
        ServiceCategorySection(
          // New key while searching so matching groups open automatically.
          key: ValueKey('$title-$searching'),
          title: title,
          services: matches,
          initiallyExpanded: searching || title == _categories.keys.first,
        ),
      );
    });

    return Scaffold(
      appBar: const AppAppBar(title: 'All Services'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 1.5.h),
            child: AppSearchField(
              controller: _controller,
              hintText: 'Search services...',
              onChanged: _setQuery,
              onClear: () {
                _controller.clear();
                _setQuery('');
              },
            ),
          ),
          Expanded(
            child: sections.isEmpty
                ? Center(
                    child: Text(
                      'No services found',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : ListView(children: sections),
          ),
        ],
      ),
    );
  }
}
