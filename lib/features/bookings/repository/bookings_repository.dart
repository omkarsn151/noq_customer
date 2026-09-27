import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/features/bookings/data/booking_created_model.dart';
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

  /// Turns the customer's cart into a booking at the chips they picked.
  ///
  /// [slots] are the UTC starts copied from the slot listing's `times[].start`,
  /// one per highlighted chip and in order; the server needs enough of them to
  /// cover the cart (see `requiredSlotCount`) and they must be back-to-back grid
  /// cells on one local day. [staffId] is one person for the whole visit, or null
  /// for Anyone. The cart is consumed on success.
  Future<BookingCreatedModel> createBooking({
    required List<DateTime> slots,
    String? staffId,
  }) async {
    final response = await _dioClient.post(
      ApiEndpoints.createBooking,
      data: {
        'slots': slots.map((s) => s.toUtc().toIso8601String()).toList(),
        // Omitted entirely for "Anyone", which the API treats the same as null.
        'staff_id': ?staffId,
      },
    );

    // The success copy differs by approval mode ("Payment Successful…" when the
    // shop auto-approves, "…will confirm it shortly" when it does not) and lives
    // on the envelope rather than inside `data`.
    return BookingCreatedModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
      message: response.data['message'] as String? ?? '',
    );
  }
}
