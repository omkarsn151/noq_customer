import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:noq/features/bookings/data/booking_model.dart';
import 'package:noq/features/bookings/data/booking_tone.dart';
import 'package:noq/features/bookings/presentation/widgets/bookings_tile.dart';

/// Placeholder booking cards shown while a tab's first page loads.
class BookingsLoadingWidget extends StatelessWidget {
  const BookingsLoadingWidget({super.key});

  // No actions, so the tile draws no ⋮ menu.
  static final _placeholder = BookingModel(
    booking: const BookingInfo(
      id: '',
      reference: '',
      status: '',
      statusLabel: 'Status',
      tone: BookingTone.info,
      tab: '',
      hasPendingReschedule: false,
      hasReviewed: false,
    ),
    business: const BookingBusiness(id: '', name: 'Business name placeholder'),
    services: const [BookingService(id: '', name: 'Service one, Service two')],
    schedule: BookingSchedule(startsAt: DateTime(2000, 1, 1, 10)),
    actions: const BookingActions(
      canReschedule: false,
      canCancel: false,
      canReview: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 2.h),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (_, _) => SizedBox(height: 2.h),
        itemBuilder: (_, _) => BookingsTile(booking: _placeholder),
      ),
    );
  }
}
