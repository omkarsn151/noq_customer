import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/business_details/data/business_details_model.dart';
import 'package:noq/features/business_details/presentation/widgets/service_tile.dart';

/// Drawn the same whether the shop picked these or the server auto-selected
/// them — the customer must not be able to tell the difference.
class PopularServicesSection extends StatelessWidget {
  final String businessId;
  final List<BusinessServiceModel> services;

  const PopularServicesSection({
    super.key,
    required this.businessId,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    // Nothing bookable: hide the heading and the "See all" link too.
    if (services.isEmpty) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Popular Services', style: textTheme.titleMedium),
              ),
              InkWell(
                onTap: () => context.push('/business-details/$businessId/services'),
                child: Text(
                  'See all',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          for (int i = 0; i < services.length; i++) ...[
            ServiceTile(service: services[i]),
            if (i != services.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                child: const Divider(height: 1, color: AppColors.borderLight),
              ),
          ],
        ],
      ),
    );
  }
}
