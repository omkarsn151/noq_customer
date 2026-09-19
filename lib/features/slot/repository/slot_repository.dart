import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/features/slot/data/slot_model.dart';

class SlotRepository {
  final DioClient _dioClient;

  SlotRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  /// Fetches the availability window for [businessId].
  ///
  /// Omitting [date] lets the backend default to today.
  Future<SlotModel> getSlots(String businessId, {String? date}) async {
    final response = await _dioClient.get(
      '${ApiEndpoints.getSlots}/$businessId/slots',
      queryParameters: date == null ? null : {'date': date},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return SlotModel.fromJson(data);
  }
}
