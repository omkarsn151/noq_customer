import 'package:noq/features/cart/data/cart_model.dart';

/// How a promo takes money off the subtotal.
enum PromoDiscountType {
  percent('percent'),
  flat('flat');

  final String value;

  const PromoDiscountType(this.value);

  static PromoDiscountType fromValue(String? value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => PromoDiscountType.flat,
  );
}

/// Stable server slugs explaining why a promo cannot be used on this cart.
/// [unknown] keeps an unrecognised reason renderable if the server adds one.
enum PromoUnavailableReason {
  paused('paused', 'Currently paused'),
  notStarted('not_started', 'Not started yet'),
  expired('expired', 'Expired'),
  minBookingNotMet('min_booking_not_met', 'Cart value too low'),
  totalLimitReached('total_limit_reached', 'Fully redeemed'),
  customerLimitReached('customer_limit_reached', 'Already used by you'),
  unknown('', 'Not available for this cart');

  final String value;
  final String label;

  const PromoUnavailableReason(this.value, this.label);

  static PromoUnavailableReason? fromValue(String? value) {
    if (value == null || value.isEmpty) return null;
    return values.firstWhere((e) => e.value == value, orElse: () => unknown);
  }
}

/// One published promo on the checkout offers sheet — usable or greyed out.
class PromoOfferModel {
  final String id;
  final String code;
  final String title;

  /// Optional blurb under the title; null when the shop left it blank.
  final String? description;

  final PromoDiscountType discountType;

  /// Percent points or a flat amount. Decimal string on the wire.
  final String discountValue;

  /// Currency cap for percent codes; null = no cap.
  final String? maxDiscountAmount;

  /// Smallest subtotal allowed to use this code; null = no minimum.
  final String? minBookingAmount;

  final DateTime? validFrom;
  final DateTime? validUntil;

  final bool isApplicable;

  /// Non-null only when [isApplicable] is false.
  final PromoUnavailableReason? unavailableReason;

  /// Savings if applied now; null when not applicable.
  final String? estimatedSavings;

  const PromoOfferModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.maxDiscountAmount,
    required this.minBookingAmount,
    required this.validFrom,
    required this.validUntil,
    required this.isApplicable,
    required this.unavailableReason,
    required this.estimatedSavings,
  });

  factory PromoOfferModel.fromJson(Map<String, dynamic> json) =>
      PromoOfferModel(
        id: json['id'] as String? ?? '',
        code: json['code'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
        discountType: PromoDiscountType.fromValue(
          json['discount_type'] as String?,
        ),
        discountValue: json['discount_value'] as String? ?? '0',
        maxDiscountAmount: json['max_discount_amount'] as String?,
        minBookingAmount: json['min_booking_amount'] as String?,
        validFrom: DateTime.tryParse(json['valid_from'] as String? ?? ''),
        validUntil: DateTime.tryParse(json['valid_until'] as String? ?? ''),
        isApplicable: json['is_applicable'] as bool? ?? false,
        unavailableReason: PromoUnavailableReason.fromValue(
          json['unavailable_reason'] as String?,
        ),
        estimatedSavings: json['estimated_savings'] as String?,
      );

  /// Headline discount, e.g. '15% OFF' or '₹100.00 OFF'.
  String get discountLabel => switch (discountType) {
    PromoDiscountType.percent => '${_trimDecimals(discountValue)}% OFF',
    PromoDiscountType.flat => '₹$discountValue OFF',
  };

  /// What this cart saves right now, or null when the server did not price it.
  String? get savingsLabel {
    final savings = estimatedSavings;
    if (savings == null || savings.isEmpty) return null;
    return 'You save ₹$savings';
  }

  /// '15.00' reads better as '15' next to a percent sign.
  static String _trimDecimals(String amount) {
    if (!amount.contains('.')) return amount;
    final trimmed = amount
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
    return trimmed.isEmpty ? '0' : trimmed;
  }
}

/// Payload of GET /customer/cart/promos — the offers sheet plus the cart's
/// current numbers.
class CartPromosModel {
  final List<PromoOfferModel> promos;

  /// The code already on this cart, or null when none is selected.
  final String? selectedPromoId;

  /// Same shape as GET /customer/cart. Parsed now because the apply ack
  /// returns it too.
  final PaymentSummary paymentSummary;

  const CartPromosModel({
    required this.promos,
    required this.selectedPromoId,
    required this.paymentSummary,
  });

  factory CartPromosModel.fromJson(Map<String, dynamic> json) =>
      CartPromosModel(
        promos: (json['promos'] as List<dynamic>? ?? const [])
            .map((e) => PromoOfferModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        selectedPromoId: json['selected_promo_id'] as String?,
        paymentSummary: PaymentSummary.fromJson(
          json['payment_summary'] as Map<String, dynamic>? ?? const {},
        ),
      );
}

/// Ack of PUT / DELETE /customer/cart/promo — the selection plus refreshed
/// payment numbers. [selectedPromo] is null after a remove, and the remove
/// response omits the key entirely.
class PromoSelectionModel {
  final SelectedPromoModel? selectedPromo;
  final PaymentSummary paymentSummary;

  const PromoSelectionModel({
    required this.selectedPromo,
    required this.paymentSummary,
  });

  factory PromoSelectionModel.fromJson(Map<String, dynamic> json) {
    final selected = json['selected_promo'] as Map<String, dynamic>?;
    return PromoSelectionModel(
      selectedPromo: selected == null
          ? null
          : SelectedPromoModel.fromJson(selected),
      paymentSummary: PaymentSummary.fromJson(
        json['payment_summary'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}
