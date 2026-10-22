import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/features/home/data/home_model.dart';

class HomeRepository {
  final DioClient _dioClient;

  HomeRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  /// Everything the Home tab shows, in one call. [lat] and [lng] are sent only
  /// together — with them, nearby shops come back nearest first.
  Future<HomeModel> getHome({double? lat, double? lng}) async {
    final response = await _dioClient.get(
      ApiEndpoints.customerHome,
      queryParameters: lat != null && lng != null
          ? {'lat': lat, 'lng': lng}
          : null,
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return HomeModel.fromJson(data);
  }
}
