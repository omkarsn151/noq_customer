import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/features/booking_detials/data/booking_details_model.dart';

class BookingDetailsRepository {
  final DioClient _dioClient;

  BookingDetailsRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  /// Pass both [lat] and [lng] to get `business.distance_km`; otherwise it
  /// comes back null and everything else is identical.
  Future<BookingDetailsModel> getBookingDetails(
    String bookingId, {
    double? lat,
    double? lng,
  }) async {
    final response = await _dioClient.get(
      '${ApiEndpoints.getBookingDetails}/$bookingId',
      queryParameters: {
        if (lat != null && lng != null) ...{'lat': lat, 'lng': lng},
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return BookingDetailsModel.fromJson(data);
  }
}
