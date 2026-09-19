import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/features/bookings/data/booking_model.dart';
import 'package:noq/features/bookings/data/booking_tab.dart';

class BookingsRepository {
  final DioClient _dioClient;

  BookingsRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  Future<PaginatedResponse<BookingModel>> getBookings({
    required BookingTab tab,
    required int page,
    required int pageSize,
  }) async {
    final response = await _dioClient.get(
      ApiEndpoints.getBookingsList,
      queryParameters: {
        'tab': tab.value,
        'page': page,
        'page_size': pageSize,
      },
    );

    // Unlike the other endpoints this keeps the whole envelope, since the
    // pagination block lives outside `data`.
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      BookingModel.fromJson,
    );
  }
}
