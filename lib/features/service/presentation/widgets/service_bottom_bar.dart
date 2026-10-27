import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_button.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/cart/bloc/add_to_cart_bloc.dart';
import 'package:noq/features/cart/bloc/add_to_cart_event.dart';
import 'package:noq/features/cart/bloc/add_to_cart_state.dart';
import 'package:noq/features/service/data/service_details_model.dart';

class ServiceBottomBar extends StatelessWidget {
  final ServiceDetailsModel service;

  const ServiceBottomBar({super.key, required this.service});

  bool _isBusy(AddToCartState state) => switch (state) {
    AddToCartLoading(:final serviceId) => serviceId == service.id,
    RemoveFromCartLoading(:final serviceId) => serviceId == service.id,
    _ => false,
  };

  void _onPressed(BuildContext context) {
    final bloc = context.read<AddToCartBloc>();
    final cartItemId = service.cartItemId;
    if (service.isInCart && cartItemId != null) {
      bloc.add(
        RemoveFromCartRequested(serviceId: service.id, cartItemId: cartItemId),
      );
    } else {
      bloc.add(AddToCartRequested(serviceId: service.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: const Border(top: BorderSide(color: AppColors.borderLight)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.pricing.label,
                  style: textTheme.bodyLarge?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '${service.durationMinutes} min',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: BlocBuilder<AddToCartBloc, AddToCartState>(
                builder: (context, state) {
                  final isBusy = _isBusy(state);
                  return AppButton(
                    label: service.isInCart ? 'Remove' : 'Add to Cart',
                    height: 6.h,
                    isLoading: isBusy,
                    leading: Icon(
                      service.isInCart
                          ? Icons.remove_shopping_cart_outlined
                          : Icons.shopping_cart_outlined,
                      color: AppColors.background,
                    ),
                    onPressed: isBusy ? null : () => _onPressed(context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
