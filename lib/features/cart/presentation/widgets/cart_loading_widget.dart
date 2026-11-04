import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:noq/features/cart/data/cart_model.dart';
import 'package:noq/features/cart/presentation/widgets/cart_content.dart';

/// Placeholder cart shaped like the loaded one while the cart loads.
class CartLoadingWidget extends StatelessWidget {
  const CartLoadingWidget({super.key});

  static const _item = CartItemModel(
    id: '',
    service: CartItemService(
      id: '',
      name: 'Service name placeholder',
      description: 'Service description placeholder text',
      thumbnailUrl: '',
    ),
    pricing: CartItemPricing(price: '000.00'),
  );

  static const _cart = CartModel(
    cart: CartInfo(id: '', business: CartBusiness(id: '', name: '')),
    items: [_item, _item],
    promo: null,
    paymentSummary: PaymentSummary(
      servicesCount: 2,
      subtotal: '000.00',
      discount: '0.00',
      taxes: '00.00',
      platformFee: '00.00',
      totalPayable: '000.00',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return const Skeletonizer(child: CartContent(cart: _cart));
  }
}
