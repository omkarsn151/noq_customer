import 'package:equatable/equatable.dart';

abstract class CancelBookingEvent extends Equatable {
  const CancelBookingEvent();

  @override
  List<Object?> get props => [];
}

class CancelBookingRequested extends CancelBookingEvent {
  final String bookingId;

  /// Null when the customer left it blank; the key is then omitted.
  final String? reason;

  const CancelBookingRequested({required this.bookingId, this.reason});

  @override
  List<Object?> get props => [bookingId, reason];
}
