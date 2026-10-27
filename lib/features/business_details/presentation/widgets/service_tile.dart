import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/business_details/data/business_details_model.dart';
import 'package:noq/features/cart/bloc/add_to_cart_bloc.dart';
import 'package:noq/features/cart/bloc/add_to_cart_event.dart';
import 'package:noq/features/cart/bloc/add_to_cart_state.dart';

class ServiceTile extends StatelessWidget {
  final String businessId;
  final BusinessServiceModel service;

  const ServiceTile({
    super.key,
    required this.businessId,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final description = service.description;

    return InkWell(
      onTap: () =>
          context.push('/business-details/$businessId/services/${service.id}'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.sp),
            child: _buildThumbnail(),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: textTheme.bodyLarge),
                if (description != null && description.isNotEmpty) ...[
                  SizedBox(height: 0.4.h),
                  Text(
                    description,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      child: Text(
                        '${service.durationMinutes} min',
                        style: textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _AddToCartButton(service: service),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          Text(service.pricing.label, style: textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    Widget placeholder() => Container(
      width: 18.w,
      height: 25.w,
      color: AppColors.borderLight,
      child: Icon(
        Icons.content_cut_rounded,
        size: 18.sp,
        color: AppColors.textSecondary,
      ),
    );

    final url = service.thumbnailUrl;
    if (url == null) return placeholder();
    return Image.network(
      url,
      width: 18.w,
      height: 25.w,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => placeholder(),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  final BusinessServiceModel service;

  const _AddToCartButton({required this.service});

  bool _isBusy(AddToCartState state) =>
      state is AddToCartLoading && state.serviceId == service.id;

  void _onPressed(BuildContext context) {
    if (service.isInCart) {
      // go() replaces the pushed shop/service pages with the Cart tab.
      context.go('/cart');
    } else {
      context.read<AddToCartBloc>().add(
        AddToCartRequested(serviceId: service.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToCartBloc, AddToCartState>(
      buildWhen: (previous, current) => _isBusy(previous) != _isBusy(current),
      builder: (context, state) {
        final isBusy = _isBusy(state);
        return InkWell(
          borderRadius: BorderRadius.circular(12.sp),
          // Its own InkWell so the tap does not open the service details.
          onTap: isBusy ? null : () => _onPressed(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.sp),
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: isBusy
                ? SizedBox(
                    width: 12.sp,
                    height: 12.sp,
                    child: const CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: AppColors.primary,
                    ),
                  )
                : Text(
                    service.isInCart ? 'GO TO CART' : 'ADD TO CART',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
