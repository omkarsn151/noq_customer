import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/business/bloc/business_bloc.dart';
import 'package:noq/features/business/bloc/business_state.dart';
import 'package:noq/features/business/data/business_model.dart';
import 'package:sizer/sizer.dart';

class BusinessList extends StatelessWidget {
  const BusinessList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessBloc, BusinessState>(
      builder: (context, state) {
        if (state is BusinessLoading || state is BusinessInitial) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is BusinessFailure) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        }

        final businesses = (state as BusinessLoaded).businesses;

        if (businesses.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No businesses found',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        }

        return Column(
          children: [
            for (final business in businesses) ...[
              _BusinessListTile(business: business),
              SizedBox(height: 1.5.h),
            ],
          ],
        );
      },
    );
  }
}

class _BusinessListTile extends StatelessWidget {
  final BusinessModel business;

  const _BusinessListTile({required this.business});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.sp),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.sp),
        onTap: () => context.push('/business/${business.id}'),
        child: Container(
          padding: EdgeInsets.all(2.5.w),
          decoration: BoxDecoration(
            color: AppColors.borderLight.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16.sp),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.sp),
                child: business.business.thumbnailUrl.isEmpty
                    ? Image.asset(
                        AppAssets.businessThumbnail,
                        width: 18.w,
                        height: 18.w,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        business.business.thumbnailUrl,
                        width: 18.w,
                        height: 18.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          AppAssets.businessThumbnail,
                          width: 18.w,
                          height: 18.w,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.business.name,
                      style: textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.4.h),
                    Text(
                      business.business.services.join(', '),
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 14.sp,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${business.rating.average.toStringAsFixed(1)} (${business.rating.totalReviews})',
                          style: textTheme.bodySmall,
                        ),
                        SizedBox(width: 3.w),
                        Icon(
                          Icons.access_time_rounded,
                          size: 14.sp,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${business.wait.minutes} min wait',
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.border),
            ],
          ),
        ),
      ),
    );
  }
}
