/// Badge colour family sent by the API next to a booking's `status_label`.
enum BookingTone {
  success,
  info,
  warning,
  danger;

  /// Unknown or missing values fall back to [info] rather than throwing.
  static BookingTone fromString(String? value) {
    return BookingTone.values.firstWhere(
      (tone) => tone.name == value,
      orElse: () => BookingTone.info,
    );
  }
}
