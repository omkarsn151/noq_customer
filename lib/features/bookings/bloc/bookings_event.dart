import 'package:equatable/equatable.dart';
import 'package:noq/features/bookings/data/booking_tab.dart';

abstract class BookingsEvent extends Equatable {
  const BookingsEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the first page of [tab]. Already loaded tabs are served from the
/// cached state unless [refresh] is set.
class BookingsRequested extends BookingsEvent {
  final BookingTab tab;
  final bool refresh;

  const BookingsRequested({required this.tab, this.refresh = false});

  @override
  List<Object?> get props => [tab, refresh];
}

/// Drops every cached tab and reloads [tab]. Used after a booking changes
/// state (created, rescheduled, cancelled), since that moves rows between tabs.
class BookingsRefreshRequested extends BookingsEvent {
  final BookingTab tab;

  const BookingsRefreshRequested({required this.tab});

  @override
  List<Object?> get props => [tab];
}

/// Appends the next page of [tab] to the already loaded bookings.
class BookingsNextPageRequested extends BookingsEvent {
  final BookingTab tab;

  const BookingsNextPageRequested({required this.tab});

  @override
  List<Object?> get props => [tab];
}
