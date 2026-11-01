/// The three filters shown as pills above the bookings list. [value] is sent
/// to the API as the `tab` query parameter.
enum BookingTab {
  upcoming('upcoming', 'Upcoming'),
  past('past', 'Past'),
  cancelled('cancelled', 'Cancelled');

  final String value;
  final String label;

  const BookingTab(this.value, this.label);

  /// The tab whose API [value] matches, or null for anything unknown so a new
  /// server-side tab never crashes parsing.
  static BookingTab? fromValue(String? value) {
    for (final tab in values) {
      if (tab.value == value) return tab;
    }
    return null;
  }
}
