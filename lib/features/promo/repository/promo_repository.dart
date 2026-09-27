import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/features/promo/data/promo_model.dart';

class PromoRepository {
  final DioClient _dioClient;

  PromoRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  /// Offers for the shop backing the current cart. Throws [ApiException] with
  /// code `CART_EMPTY` when the basket has no live services.
  Future<CartPromosModel> getCartPromos() async {
    final response = await _dioClient.get(ApiEndpoints.getPromoCodes);
    final data = response.data['data'] as Map<String, dynamic>;
    return CartPromosModel.fromJson(data);
  }

  /// Selects one usable code, replacing any previous selection. Only remembers
  /// the choice — the code is held when the booking is created.
  ///
  /// Throws [ApiException] with code `PROMO_NOT_APPLICABLE`, `PROMO_NOT_FOUND`
  /// or `CART_EMPTY`.
  Future<PromoSelectionModel> applyPromo(String promoId) async {
    final response = await _dioClient.put(
      ApiEndpoints.applyPromoCode,
      data: {'promo_id': promoId},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return PromoSelectionModel.fromJson(data);
  }

  /// Clears the selected code. Idempotent when none is selected.
  Future<PromoSelectionModel> removePromo() async {
    final response = await _dioClient.delete(ApiEndpoints.removePromoCode);
    final data = response.data['data'] as Map<String, dynamic>;
    return PromoSelectionModel.fromJson(data);
  }
}
