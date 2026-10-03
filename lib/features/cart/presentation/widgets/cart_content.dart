import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/cart/data/cart_model.dart';
import 'package:noq/features/cart/presentation/widgets/apply_promo_tile.dart';
import 'package:noq/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:noq/features/cart/presentation/widgets/checkout_bar.dart';
import 'package:noq/features/cart/presentation/widgets/payment_summary_section.dart';

class CartContent extends StatelessWidget {
  final CartModel cart;
  final String? removingItemId;

  const CartContent({super.key, required this.cart, this.removingItemId});

  @override
  Widget build(BuildContext context) {
    final summary = cart.paymentSummary;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < cart.items.length; i++) ...[
                    CartItemTile(
                      item: cart.items[i],
                      isRemoving: cart.items[i].id == removingItemId,
                    ),
                    if (i != cart.items.length - 1)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        child: const Divider(
                          height: 1,
                          color: AppColors.borderLight,
                        ),
                      ),
                  ],
                  SizedBox(height: 3.h),
                  const ApplyPromoTile(),
                  SizedBox(height: 3.h),
                  PaymentSummarySection(cart: cart),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
        CheckoutBar(
          servicesCount: summary.servicesCount,
          totalPayable: summary.totalPayable,
          businessId: cart.cart.business.id,
        ),
      ],
    );
  }
}
