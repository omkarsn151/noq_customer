import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/common/app_search_field.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/search/presentation/widgets/quick_filters_section.dart';
import 'package:noq/features/search/presentation/widgets/recent_searches_section.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.searchScreenBackground,
      appBar: const AppAppBar(title: 'Search'),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25.sp),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 2.5.h),
                    child: AppSearchField(
                      controller: _controller,
                      hintText: 'Search clinics, barbers, DMV...',
                      onChanged: (value) => setState(() {}),
                      onClear: () => setState(_controller.clear),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 2.5.h),
                  const QuickFiltersSection(),
                  SizedBox(height: 3.h),
                  const RecentSearchesSection(),
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
