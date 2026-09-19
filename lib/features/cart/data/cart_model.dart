class CartBusiness {
  final String id;
  final String name;

  const CartBusiness({required this.id, required this.name});

  factory CartBusiness.fromJson(Map<String, dynamic> json) => CartBusiness(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
      );
}

class CartInfo {
  final String id;
  final CartBusiness business;

  const CartInfo({required this.id, required this.business});

  factory CartInfo.fromJson(Map<String, dynamic> json) => CartInfo(
        id: json['id'] as String? ?? '',
        business: CartBusiness.fromJson(
          json['business'] as Map<String, dynamic>? ?? {},
        ),
      );
}

class CartItemService {
  final String id;
  final String name;
  final String description;
  final String thumbnailUrl;

  const CartItemService({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
  });

  factory CartItemService.fromJson(Map<String, dynamic> json) =>
      CartItemService(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      );
}

class CartItemPricing {
  final String price;

  const CartItemPricing({required this.price});

  factory CartItemPricing.fromJson(Map<String, dynamic> json) =>
      CartItemPricing(price: json['price'] as String? ?? '0');
}

class CartItemModel {
  final String id;
  final CartItemService service;
  final CartItemPricing pricing;

  const CartItemModel({
    required this.id,
    required this.service,
    required this.pricing,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: json['id'] as String? ?? '',
        service: CartItemService.fromJson(
          json['service'] as Map<String, dynamic>? ?? {},
        ),
        pricing: CartItemPricing.fromJson(
          json['pricing'] as Map<String, dynamic>? ?? {},
        ),
      );
}

class PaymentSummary {
  final int servicesCount;
  final String subtotal;
  final String discount;
  final String taxes;
  final String platformFee;
  final String totalPayable;

  const PaymentSummary({
    required this.servicesCount,
    required this.subtotal,
    required this.discount,
    required this.taxes,
    required this.platformFee,
    required this.totalPayable,
  });

  factory PaymentSummary.fromJson(Map<String, dynamic> json) => PaymentSummary(
        servicesCount: (json['services_count'] as num? ?? 0).toInt(),
        subtotal: json['subtotal'] as String? ?? '0',
        discount: json['discount'] as String? ?? '0',
        taxes: json['taxes'] as String? ?? '0',
        platformFee: json['platform_fee'] as String? ?? '0',
        totalPayable: json['total_payable'] as String? ?? '0',
      );
}

class CartModel {
  final CartInfo cart;
  final List<CartItemModel> items;
  final PaymentSummary paymentSummary;

  const CartModel({
    required this.cart,
    required this.items,
    required this.paymentSummary,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        cart: CartInfo.fromJson(json['cart'] as Map<String, dynamic>? ?? {}),
        items: (json['items'] as List<dynamic>? ?? [])
            .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        paymentSummary: PaymentSummary.fromJson(
          json['payment_summary'] as Map<String, dynamic>? ?? {},
        ),
      );
}
