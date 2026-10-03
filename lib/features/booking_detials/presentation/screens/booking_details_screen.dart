import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:noq/features/booking_detials/presentation/widgets/verification_code_card.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/features/booking_detials/presentation/widgets/booking_status_card.dart';
import 'package:noq/features/booking_detials/presentation/widgets/business_header.dart';
import 'package:noq/features/booking_detials/presentation/widgets/details_card.dart';
import 'package:noq/features/booking_detials/presentation/widgets/info_row.dart';
import 'package:noq/features/booking_detials/presentation/widgets/manage_booking_card.dart';
import 'package:noq/features/booking_detials/presentation/widgets/payment_card.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String bookingId;
  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'Booking #BK1234'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BusinessHeader(
                name: 'Dentistry Dental',
                distance: '1.2 Kms Away',
                openTill: 'Opens till 8 PM',
              ),
              SizedBox(height: 2.h),
              const BookingStatusCard(
                status: 'confirmed',
                message: 'Your slot is secured, please arrive 10 mins earlier',
              ),
              SizedBox(height: 1.5.h),
              const VerificationCodeCard(code: '4821'),
              SizedBox(height: 1.5.h),
              DetailsCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CardTitle('Booking Info'),
                    SizedBox(height: 0.5.h),
                    InfoRow(
                      icon: Icons.confirmation_number_outlined,
                      label: 'Booking Reference ID',
                      value: '#BK1234',
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
                      label: 'Service',
                      value: 'Teeth Cleaning  •  ₹800',
                    ),
                    InfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Date',
                      value: '12 Oct 2026',
                    ),
                    InfoRow(
                      icon: Icons.access_time_rounded,
                      label: 'Time',
                      value: '04:00 PM',
                    ),
                    InfoRow(
                      icon: Icons.timelapse_rounded,
                      label: 'Duration',
                      value: '45 mins',
                    ),
                    InfoRow(
                      icon: Icons.person_outline,
                      label: 'Requested Staff',
                      value: 'Dr. Sharma',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1.5.h),
              const PaymentCard(),
              SizedBox(height: 1.5.h),
              ManageBookingCard(
                onReschedule: () {
                  context.push('/reschedule-slot');
                },
                onCancel: () {},
              ),
              SizedBox(height: 1.5.h),
            ],
          ),
        ),
      ),
    );
  }
}
