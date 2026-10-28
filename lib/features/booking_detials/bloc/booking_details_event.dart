import 'package:equatable/equatable.dart';

abstract class BookingDetailsEvent extends Equatable {
  const BookingDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// Loads (or reloads) one booking.
class BookingDetailsRequested extends BookingDetailsEvent {
  final String bookingId;

  const BookingDetailsRequested({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}
