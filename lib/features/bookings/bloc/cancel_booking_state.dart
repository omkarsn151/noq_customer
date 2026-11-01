import 'package:equatable/equatable.dart';
import 'package:noq/features/bookings/data/booking_cancelled_model.dart';

abstract class CancelBookingState extends Equatable {
  const CancelBookingState();

  @override
  List<Object?> get props => [];
}

class CancelBookingInitial extends CancelBookingState {
  const CancelBookingInitial();
}

/// [bookingId] lets the list show a spinner on just the tapped card.
class CancelBookingInProgress extends CancelBookingState {
  final String bookingId;

  const CancelBookingInProgress({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

class CancelBookingSuccess extends CancelBookingState {
  final String bookingId;
  final BookingCancelledModel result;

  const CancelBookingSuccess({required this.bookingId, required this.result});

  @override
  List<Object?> get props => [bookingId, result];
}

class CancelBookingFailure extends CancelBookingState {
  final String bookingId;
  final String message;
  final String? code;

  const CancelBookingFailure({
    required this.bookingId,
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [bookingId, message, code];
}
