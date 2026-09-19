/// The three filters shown as pills above the bookings list. [value] is sent
/// to the API as the `tab` query parameter.
enum BookingTab {
  upcoming('upcoming', 'Upcoming'),
  past('past', 'Past'),
  cancelled('cancelled', 'Cancelled');

  final String value;
  final String label;

  const BookingTab(this.value, this.label);
}
