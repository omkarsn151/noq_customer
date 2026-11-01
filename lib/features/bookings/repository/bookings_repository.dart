import 'package:noq/core/api/api_endpoints.dart';
import 'package:noq/core/api/dio_client.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/features/bookings/data/booking_cancelled_model.dart';
import 'package:noq/features/bookings/data/booking_created_model.dart';
import 'package:noq/features/bookings/data/booking_model.dart';
import 'package:noq/features/bookings/data/booking_rescheduled_model.dart';
import 'package:noq/features/bookings/data/booking_tab.dart';

class BookingsRepository {
  static const int defaultPageSize = 10;

  final DioClient _dioClient;

  BookingsRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  Future<PaginatedResponse<BookingModel>> getBookings({
    required BookingTab tab,
    int page = 1,
    int pageSize = defaultPageSize,
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

  /// Cancels a pending or confirmed booking. [reason] is optional (max 500) and
  /// shown to the shop; omitted entirely when null. Safe to repeat: a second
  /// cancel returns 200 with the original reason. Also withdraws any reschedule
  /// request still waiting on the shop.
  Future<BookingCancelledModel> cancelBooking(
    String bookingId, {
    String? reason,
  }) async {
    final response = await _dioClient.post(
      '${ApiEndpoints.cancelBooking}/$bookingId/cancel',
      data: {'reason': ?reason},
    );
    return BookingCancelledModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
      message: response.data['message'] as String? ?? '',
    );
  }

  /// Asks to move a confirmed booking to new consecutive chips. Same body as
  /// [createBooking]. The booking only moves when the result's outcome is
  /// `moved`; see [RescheduleOutcome].
  Future<BookingRescheduledModel> rescheduleBooking(
    String bookingId, {
    required List<DateTime> slots,
    String? staffId,
  }) async {
    final response = await _dioClient.post(
      '${ApiEndpoints.rescheduleBooking}/$bookingId/reschedule',
      data: {
        'slots': slots.map((s) => s.toUtc().toIso8601String()).toList(),
        // Omitted entirely for "Anyone", which the API treats the same as null.
        'staff_id': ?staffId,
      },
    );
    return BookingRescheduledModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
      message: response.data['message'] as String? ?? '',
    );
  }
}
