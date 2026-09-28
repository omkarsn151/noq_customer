import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/common/app_button.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/bookings/data/booking_created_model.dart';
import 'package:noq/features/bookings/presentation/widgets/booking_status_label.dart';
import 'package:sizer/sizer.dart';

class BookingSuccessScreen extends StatelessWidget {
  final BookingCreatedModel booking;

  const BookingSuccessScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppAppBar(title: 'Booking Confirmed'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppAssets.paymentSuccess),
              SizedBox(height: 2.h),
              BookingStatusLabel(status: booking.status),
              SizedBox(height: 1.h),
              Text(
                booking.message,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 4.h),
              AppButton(
                label: 'View My Bookings',
                onPressed: () => context.go('/bookings'),
              ),
              SizedBox(height: 1.h),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
