import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/core/utils/date_time_utils.dart';
import 'package:noq/features/booking_detials/data/booking_details_model.dart';
import 'package:noq/features/booking_detials/presentation/widgets/details_card.dart';
import 'package:noq/features/booking_detials/presentation/widgets/info_row.dart';

/// Cancellation, rejection and reschedule details, each value printed as the
/// API sends it. Renders nothing when the booking has none of them.
class BookingNoticeCard extends StatelessWidget {
  final BookingDetailsModel details;

  const BookingNoticeCard({super.key, required this.details});

  static bool hasContent(BookingDetailsModel details) =>
      details.cancellation != null ||
      details.rejection?.reason != null ||
      details.reschedule != null;

  /// The API sends a role, not a name. Anything other than the customer or the
  /// shop (e.g. a request that expired) is shown as-is, never as "You".
  String _cancelledByLabel(String cancelledBy) {
    switch (cancelledBy) {
      case 'customer':
        return 'You';
      case 'business':
        final name = details.business.name;
        return name.isEmpty ? 'Shop' : name;
      default:
        return _capitalise(cancelledBy);
    }
  }

  static String _capitalise(String value) =>
      value.isEmpty ? '--' : value[0].toUpperCase() + value.substring(1);

  /// Who asked and what happened decide the wording. A pending customer request
  /// has not moved the booking, so its time is "requested", not "new".
  ({String title, String whoLabel, String timeLabel, String? note})
  _rescheduleCopy(BookingReschedule r) {
    if (r.requestedByRole == 'business') {
      return (
        title: 'Rescheduled',
        whoLabel: 'Rescheduled by',
        timeLabel: 'New time',
        note: null,
      );
    }
    if (r.requestedByRole == 'customer') {
      switch (r.status) {
        case 'pending':
          return (
            title: 'Reschedule Requested',
            whoLabel: 'Requested by',
            timeLabel: 'Requested time',
            note:
                'Waiting for the shop to respond. Your booking stays at its '
                'current time until then.',
          );
        case 'approved':
          return (
            title: 'Rescheduled',
            whoLabel: 'Requested by',
            timeLabel: 'New time',
            note: null,
          );
        case 'rejected':
          return (
            title: 'Reschedule Declined',
            whoLabel: 'Requested by',
            timeLabel: 'Requested time',
            note: 'The shop kept your original time.',
          );
      }
    }
    return (
      title: 'Reschedule',
      whoLabel: 'Requested by',
      timeLabel: 'Proposed time',
      note: null,
    );
  }

  /// Whether [_rescheduleCopy] fell through to the generic rows, which also
  /// print the raw status since the title does not explain it.
  static bool _isKnownReschedule(BookingReschedule r) =>
      r.requestedByRole == 'business' ||
      (r.requestedByRole == 'customer' &&
          const {'pending', 'approved', 'rejected'}.contains(r.status));

  String _dateTime(DateTime dateTime) =>
      '${DateTimeUtils.formatFullDate(dateTime)}, '
      '${DateTimeUtils.formatSlotTime(dateTime)}';

  @override
  Widget build(BuildContext context) {
    if (!hasContent(details)) return const SizedBox.shrink();

    final cancellation = details.cancellation;
    final rejection = details.rejection;
    final reschedule = details.reschedule;
    final rescheduleCopy = reschedule == null
        ? null
        : _rescheduleCopy(reschedule);

    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cancellation != null) ...[
            const CardTitle('Cancellation'),
            InfoRow(
              icon: Icons.person_outline,
              label: 'Cancelled by',
              value: _cancelledByLabel(cancellation.cancelledBy),
            ),
            if (cancellation.cancelledAt != null)
              InfoRow(
                icon: Icons.event_busy_outlined,
                label: 'Cancelled on',
                value: _dateTime(cancellation.cancelledAt!),
              ),
            if (cancellation.reason != null)
              InfoRow(
                icon: Icons.notes_rounded,
                label: 'Reason',
                value: cancellation.reason!,
              ),
            if (cancellation.hasFee)
              InfoRow(
                icon: Icons.receipt_long_outlined,
                label: 'Cancellation fee',
                value: details.payment.format(cancellation.fee),
              ),
          ],
          if (rejection?.reason != null) ...[
            const CardTitle('Rejection'),
            InfoRow(
              icon: Icons.notes_rounded,
              label: 'Reason',
              value: rejection!.reason!,
            ),
          ],
          if (reschedule != null && rescheduleCopy != null) ...[
            if (cancellation != null || rejection?.reason != null)
              SizedBox(height: 2.h),
            CardTitle(rescheduleCopy.title),
            InfoRow(
              icon: Icons.person_outline,
              label: rescheduleCopy.whoLabel,
              value: reschedule.requestedByName,
            ),
            if (reschedule.requestedAt != null)
              InfoRow(
                icon: Icons.event_note_outlined,
                label: 'Requested on',
                value: _dateTime(reschedule.requestedAt!),
              ),
            if (!_isKnownReschedule(reschedule))
              InfoRow(
                icon: Icons.sync_rounded,
                label: 'Status',
                value: _capitalise(reschedule.status),
              ),
            if (reschedule.proposedStart != null)
              InfoRow(
                icon: Icons.schedule_rounded,
                label: rescheduleCopy.timeLabel,
                value: DateTimeUtils.formatBookingDateTime(
                  reschedule.proposedStart!,
                  relative: false,
                ),
              ),
            if (rescheduleCopy.note != null) ...[
              SizedBox(height: 0.5.h),
              Text(
                rescheduleCopy.note!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
