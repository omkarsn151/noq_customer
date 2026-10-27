import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/business_details/presentation/widgets/service_tile.dart';
import 'package:noq/features/service_list/bloc/service_list_state.dart';
import 'package:noq/features/service_list/data/service_list_model.dart';

class ServiceCategorySection extends StatefulWidget {
  final String businessId;
  final ShopSectionModel section;

  /// Null until the section has been opened at least once.
  final SectionServices? services;

  /// Called every time the section is opened; the bloc skips cached sections.
  final VoidCallback onExpand;

  final bool initiallyExpanded;

  const ServiceCategorySection({
    super.key,
    required this.businessId,
    required this.section,
    required this.services,
    required this.onExpand,
    this.initiallyExpanded = false,
  });

  @override
  State<ServiceCategorySection> createState() => _ServiceCategorySectionState();
}

class _ServiceCategorySectionState extends State<ServiceCategorySection> {
  late bool _expanded = widget.initiallyExpanded;

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) widget.onExpand();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _toggle,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.section.name,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '(${widget.section.serviceCount})',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: _expanded
                ? Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 2.h),
                    child: _buildBody(textTheme),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(TextTheme textTheme) {
    final services = widget.services;

    if (services == null || services.status == SectionServicesStatus.loading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (services.status == SectionServicesStatus.failure) {
      return Column(
        children: [
          Text(
            services.message,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          TextButton(onPressed: widget.onExpand, child: const Text('Retry')),
        ],
      );
    }

    final items = services.items;
    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          ServiceTile(businessId: widget.businessId, service: items[i]),
          if (i != items.length - 1)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              child: const Divider(height: 1, color: AppColors.borderLight),
            ),
        ],
      ],
    );
  }
}
