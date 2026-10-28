import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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

  String _dateTime(DateTime dateTime) =>
      '${DateTimeUtils.formatFullDate(dateTime)}, '
      '${DateTimeUtils.formatSlotTime(dateTime)}';

  @override
  Widget build(BuildContext context) {
    if (!hasContent(details)) return const SizedBox.shrink();

    final cancellation = details.cancellation;
    final rejection = details.rejection;
    final reschedule = details.reschedule;

    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cancellation != null) ...[
            const CardTitle('Cancellation'),
            InfoRow(
              icon: Icons.person_outline,
              label: 'Cancelled by',
              value: cancellation.cancelledBy,
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
          if (reschedule != null) ...[
            if (cancellation != null || rejection?.reason != null)
              SizedBox(height: 2.h),
            const CardTitle('Reschedule'),
            InfoRow(
              icon: Icons.person_outline,
              // Doc: customer → "Requested by", business → "Rescheduled by".
              label: reschedule.requestedByRole == 'business'
                  ? 'Rescheduled by'
                  : 'Requested by',
              value: reschedule.requestedByName,
            ),
            InfoRow(
              icon: Icons.sync_rounded,
              label: 'Status',
              value: reschedule.status,
            ),
            if (reschedule.proposedStart != null)
              InfoRow(
                icon: Icons.schedule_rounded,
                label: 'Proposed time',
                value: _dateTime(reschedule.proposedStart!),
              ),
          ],
        ],
      ),
    );
  }
}
