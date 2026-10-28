/// Lightweight date/time formatting helpers.
///
/// The project does not depend on `intl`, so the few formats the app needs are
/// hand-rolled here.
class DateTimeUtils {
  DateTimeUtils._();

  /// Formats a slot timestamp as a 12-hour clock label in the device's local
  /// timezone, e.g. `2026-08-21T04:30:00Z` -> `10:00 AM` on an IST device.
  static String formatSlotTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final isAm = local.hour < 12;
    final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    return '${hour12.toString().padLeft(2, '0')}:$minute ${isAm ? 'AM' : 'PM'}';
  }

  /// Today's local date as an ISO `yyyy-MM-dd` string.
  static String todayIsoDate() => toIsoDate(DateTime.now());

  /// Formats a [DateTime] as an ISO `yyyy-MM-dd` string.
  static String toIsoDate(DateTime dateTime) {
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '${dateTime.year}-$month-$day';
  }

  /// Relative age label, e.g. `just now`, `5 min ago`, `2 days ago`,
  /// `3 weeks ago`, falling back to `Jun 09, 2026` after a year.
  static String timeAgo(DateTime dateTime) {
    final local = dateTime.toLocal();
    final diff = DateTime.now().difference(local);

    String plural(int n, String unit) => '$n $unit${n == 1 ? '' : 's'} ago';

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes} min ago';
    if (diff.inDays < 1) return plural(diff.inHours, 'hour');
    if (diff.inDays < 7) return plural(diff.inDays, 'day');
    if (diff.inDays < 30) return plural(diff.inDays ~/ 7, 'week');
    if (diff.inDays < 365) return plural(diff.inDays ~/ 30, 'month');
    return '${_monthAbbr[local.month - 1]} '
        '${local.day.toString().padLeft(2, '0')}, ${local.year}';
  }

  static const List<String> _monthAbbr = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Full date in the device's local timezone, e.g. `12 Oct 2026`.
  static String formatFullDate(DateTime dateTime) {
    final local = dateTime.toLocal();
    return '${local.day.toString().padLeft(2, '0')} '
        '${_monthAbbr[local.month - 1]} ${local.year}';
  }

  /// Length label, e.g. `45 mins`, `1 hr`, `1 hr 15 mins`.
  static String formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    final minLabel = '$mins min${mins == 1 ? '' : 's'}';
    if (hours == 0) return minLabel;
    final hourLabel = '$hours hr${hours == 1 ? '' : 's'}';
    return mins == 0 ? hourLabel : '$hourLabel $minLabel';
  }

  /// A plain 24-hour `HH:MM` clock string as a 12-hour label, e.g.
  /// `20:00` -> `8 PM`, `20:30` -> `8:30 PM`. Returns null when malformed.
  /// No timezone conversion — the string is already the shop's local time.
  static String? formatClockString(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null || hour > 23 || minute > 59) {
      return null;
    }
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final suffix = hour < 12 ? 'AM' : 'PM';
    return minute == 0
        ? '$hour12 $suffix'
        : '$hour12:${minute.toString().padLeft(2, '0')} $suffix';
  }

  /// Booking list label in the device's local timezone, e.g. `Today, 04:00 PM`,
  /// `Tomorrow, 06:00 PM` or `Jun 09, 07:00 PM`. With [relative] off the date
  /// is always written out, which suits the history tabs (Past, Cancelled).
  static String formatBookingDateTime(
    DateTime dateTime, {
    bool relative = true,
  }) {
    final local = dateTime.toLocal();
    final date = toIsoDate(local);

    final String dayLabel;
    if (relative && date == todayIsoDate()) {
      dayLabel = 'Today';
    } else if (relative &&
        date == toIsoDate(DateTime.now().add(const Duration(days: 1)))) {
      dayLabel = 'Tomorrow';
    } else {
      dayLabel =
          '${_monthAbbr[local.month - 1]} ${local.day.toString().padLeft(2, '0')}';
    }

    return '$dayLabel, ${formatSlotTime(local)}';
  }
}
