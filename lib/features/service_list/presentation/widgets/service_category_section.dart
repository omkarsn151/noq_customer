import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/business_details/presentation/widgets/service_tile.dart';

class ServiceCategorySection extends StatefulWidget {
  final String title;
  final List<ServiceItem> services;
  final bool initiallyExpanded;

  const ServiceCategorySection({
    super.key,
    required this.title,
    required this.services,
    this.initiallyExpanded = false,
  });

  @override
  State<ServiceCategorySection> createState() => _ServiceCategorySectionState();
}

class _ServiceCategorySectionState extends State<ServiceCategorySection> {
  late bool _expanded = widget.initiallyExpanded;

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
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Row(
                children: [
                  Text(
                    widget.title,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '(${widget.services.length})',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
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
                    child: Column(
                      children: [
                        for (int i = 0; i < widget.services.length; i++) ...[
                          ServiceTile(service: widget.services[i]),
                          if (i != widget.services.length - 1)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              child: const Divider(
                                height: 1,
                                color: AppColors.borderLight,
                              ),
                            ),
                        ],
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
