import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/features/cart/data/cart_model.dart';

class CartRepository {
  final DioClient _dioClient;

  CartRepository({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  Future<String> addToCart(String serviceId) async {
    final response = await _dioClient.post(
      ApiEndpoints.addToCart,
      data: {'service_id': serviceId},
    );

    return response.data['message'] as String? ?? 'Added to cart';
  }

  Future<CartModel> getCart() async {
    final response = await _dioClient.get(ApiEndpoints.getCartItems);
    final data = response.data['data'] as Map<String, dynamic>;
    return CartModel.fromJson(data);
  }

  Future<String> removeCartItem(String itemId) async {
    final response = await _dioClient.delete(
      '${ApiEndpoints.removeCartItem}/$itemId',
    );

    return response.data['message'] as String? ?? 'Removed from cart';
  }
}
