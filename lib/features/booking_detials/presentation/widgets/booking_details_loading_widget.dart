import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:noq/features/booking_detials/data/booking_details_model.dart';
import 'package:noq/features/booking_detials/presentation/widgets/booking_status_card.dart';
import 'package:noq/features/booking_detials/presentation/widgets/business_header.dart';
import 'package:noq/features/booking_detials/presentation/widgets/details_card.dart';
import 'package:noq/features/booking_detials/presentation/widgets/info_row.dart';
import 'package:noq/features/booking_detials/presentation/widgets/payment_card.dart';
import 'package:noq/features/bookings/data/booking_tone.dart';

/// Placeholder Booking Details page shaped like the loaded one while it loads.
class BookingDetailsLoadingWidget extends StatelessWidget {
  const BookingDetailsLoadingWidget({super.key});

  static const _payment = BookingDetailsPayment(
    subtotal: '000.00',
    discount: '0',
    total: '000.00',
    currencyCode: 'INR',
    promo: null,
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BusinessHeader(
              name: 'Business name placeholder',
              distance: '0.0 Kms Away',
              openTill: 'Opens till 0:00 PM',
            ),
            SizedBox(height: 2.h),
            const BookingStatusCard(
              label: 'Booking status',
              message: 'Booking status message placeholder',
              tone: BookingTone.info,
            ),
            SizedBox(height: 1.5.h),
            DetailsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CardTitle('Booking Info'),
                  SizedBox(height: 0.5.h),
                  const InfoRow(
                    icon: Icons.confirmation_number_outlined,
                    label: 'Booking Reference ID',
                    value: '#REF0000',
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.5.h),
            const DetailsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardTitle('Appointment Details'),
                  InfoRow(
                    icon: Icons.design_services_rounded,
                    label: 'Service name',
                    value: '₹000  •  30 min',
                  ),
                  InfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Date',
                    value: 'Mon, 00 Jan 0000',
                  ),
                  InfoRow(
                    icon: Icons.access_time_rounded,
                    label: 'Time',
                    value: '00:00 AM',
                  ),
                  InfoRow(
                    icon: Icons.timelapse_rounded,
                    label: 'Duration',
                    value: '30 min',
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.5.h),
            const PaymentCard(payment: _payment),
          ],
        ),
      ),
    );
  }
}
