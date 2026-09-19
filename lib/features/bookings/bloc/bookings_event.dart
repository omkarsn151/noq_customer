import 'package:equatable/equatable.dart';
import 'package:noq/features/bookings/data/booking_tab.dart';

abstract class BookingsEvent extends Equatable {
  const BookingsEvent();

  @override
  List<Object?> get props => [];
}

/// First load of the screen.
class BookingsRequested extends BookingsEvent {
  final BookingTab tab;

  const BookingsRequested({this.tab = BookingTab.upcoming});

  @override
  List<Object?> get props => [tab];
}

/// Pill tap; ignored when the tab is already selected.
class BookingsTabChanged extends BookingsEvent {
  final BookingTab tab;

  const BookingsTabChanged(this.tab);

  @override
  List<Object?> get props => [tab];
}

/// Pull-to-refresh; reloads page 1 of the current tab.
class BookingsRefreshed extends BookingsEvent {
  const BookingsRefreshed();
}

/// Fired by the scroll listener as the list nears its end.
class BookingsNextPageRequested extends BookingsEvent {
  const BookingsNextPageRequested();
}
