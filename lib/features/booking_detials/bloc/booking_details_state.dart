import 'package:equatable/equatable.dart';
import 'package:noq/features/booking_detials/data/booking_details_model.dart';

/// [notFound]: unknown booking or somebody else's — pop back to the list,
/// do not retry.
enum BookingDetailsStatus { initial, loading, success, failure, notFound }

class BookingDetailsState extends Equatable {
  final BookingDetailsStatus status;

  /// Null until the first successful load.
  final BookingDetailsModel? details;

  final String message;
  final String bookingId;

  const BookingDetailsState({
    this.status = BookingDetailsStatus.initial,
    this.details,
    this.message = '',
    this.bookingId = '',
  });

  BookingDetailsState copyWith({
    BookingDetailsStatus? status,
    BookingDetailsModel? details,
    String? message,
  }) {
    return BookingDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      message: message ?? this.message,
      bookingId: bookingId,
    );
  }

  @override
  List<Object?> get props => [status, details, message, bookingId];
}
