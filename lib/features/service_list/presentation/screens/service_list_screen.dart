import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/common/app_search_field.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/business_details/presentation/widgets/service_tile.dart';
import 'package:noq/features/service_list/presentation/widgets/service_category_section.dart';

const _haircut = ServiceItem(
  name: 'Classic Haircut',
  description: 'Wash, cut and blow dry by our expert stylists.',
  durationMinutes: 30,
  price: 499,
  thumbnail: AppAssets.serviceThumbnail,
);
const _facial = ServiceItem(
  name: 'Deep Cleansing Facial',
  description: 'Refreshing facial for glowing, healthy skin.',
  durationMinutes: 45,
  price: 899,
  thumbnail: AppAssets.serviceThumbnail2,
);
const _spa = ServiceItem(
  name: 'Relaxing Body Spa',
  description: 'Full body massage to relieve stress and tension.',
  durationMinutes: 60,
  price: 1499,
  thumbnail: AppAssets.serviceThumbnail3,
);

const _categories = <String, List<ServiceItem>>{
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
