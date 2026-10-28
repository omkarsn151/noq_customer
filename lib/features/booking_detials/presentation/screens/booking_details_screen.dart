import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/core/utils/date_time_utils.dart';
import 'package:noq/features/booking_detials/bloc/booking_details_bloc.dart';
import 'package:noq/features/booking_detials/bloc/booking_details_event.dart';
import 'package:noq/features/booking_detials/bloc/booking_details_state.dart';
import 'package:noq/features/booking_detials/data/booking_details_model.dart';
import 'package:noq/features/booking_detials/presentation/widgets/booking_notice_card.dart';
import 'package:noq/features/booking_detials/presentation/widgets/booking_status_card.dart';
import 'package:noq/features/booking_detials/presentation/widgets/business_header.dart';
import 'package:noq/features/booking_detials/presentation/widgets/details_card.dart';
import 'package:noq/features/booking_detials/presentation/widgets/info_row.dart';
import 'package:noq/features/booking_detials/presentation/widgets/manage_booking_card.dart';
import 'package:noq/features/booking_detials/presentation/widgets/payment_card.dart';
import 'package:noq/features/booking_detials/presentation/widgets/verification_code_card.dart';

class BookingDetailsScreen extends StatefulWidget {
  final String bookingId;
  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<BookingDetailsBloc>().add(
      BookingDetailsRequested(bookingId: widget.bookingId),
    );
  }

  bool _isCurrent(BookingDetailsState state) =>
      state.bookingId == widget.bookingId;

  Future<void> _reschedule() async {
    await context.push('/reschedule-slot');
    // The booking may have moved or gained a pending request.
    if (mounted) _load();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingDetailsBloc, BookingDetailsState>(
      listenWhen: (previous, current) =>
          _isCurrent(current) && current.status != previous.status,
      listener: (context, state) {
        if (state.status == BookingDetailsStatus.notFound) {
          // Unknown or somebody else's booking — back to the list, no error page.
          AppSnackbar.show(
            context,
            message: state.message,
            type: AppSnackBarType.error,
          );
          context.pop();
        }
      },
      builder: (context, state) => _buildScaffold(state),
    );
  }

  Widget _buildScaffold(BookingDetailsState state) {
    // The bloc is app-wide, so ignore another booking's data.
    final details = _isCurrent(state) ? state.details : null;

    if (details != null && state.status == BookingDetailsStatus.success) {
      return Scaffold(
        appBar: AppAppBar(title: 'Booking #${details.booking.reference}'),
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => _load(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
              child: _BookingDetailsBody(
                details: details,
                onReschedule: _reschedule,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const AppAppBar(title: 'Booking Details'),
      body: _isCurrent(state) && state.status == BookingDetailsStatus.failure
          ? _BookingDetailsMessage(message: state.message, onRetry: _load)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _BookingDetailsBody extends StatelessWidget {
  final BookingDetailsModel details;
  final VoidCallback onReschedule;

  const _BookingDetailsBody({
    required this.details,
    required this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final booking = details.booking;
    final business = details.business;
    final schedule = details.schedule;
    final startsAt = schedule.startsAt;
    final verificationCode = booking.verificationCode;
    final closesAt = business.closesAt == null
        ? null
        : DateTimeUtils.formatClockString(business.closesAt!);
    final hasDirections =
        business.location.latitude != null &&
        business.location.directionsUrl != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BusinessHeader(
          name: business.name,
          thumbnailUrl: business.thumbnailUrl,
          distance: business.distanceKm == null
              ? null
              : '${business.distanceKm} Kms Away',
          openTill: closesAt == null ? null : 'Opens till $closesAt',
          directionsUrl: hasDirections ? business.location.directionsUrl : null,
          onTap: business.id.isEmpty
              ? null
              : () => context.push('/business-details/${business.id}'),
        ),
        SizedBox(height: 2.h),
        BookingStatusCard(
          label: booking.statusLabel,
          message: booking.statusMessage,
          tone: booking.tone,
        ),
        if (BookingNoticeCard.hasContent(details)) ...[
          SizedBox(height: 1.5.h),
          BookingNoticeCard(details: details),
        ],
        if (verificationCode != null) ...[
          SizedBox(height: 1.5.h),
          VerificationCodeCard(code: verificationCode),
        ],
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
                value: '#${booking.reference}',
              ),
            ],
          ),
        ),
        SizedBox(height: 1.5.h),
        DetailsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardTitle('Appointment Details'),
              for (final service in details.services) ...[
                InfoRow(
                  icon: Icons.design_services_rounded,
                  label: service.name,
                  value:
                      '${details.payment.format(service.price)}  •  '
                      '${DateTimeUtils.formatDuration(service.durationMinutes)}',
                ),
                if (service.staff != null)
                  InfoRow(
                    icon: Icons.person_outline,
                    label: 'Requested Staff',
                    value: service.staff!.name,
                  ),
              ],
              if (startsAt != null) ...[
                InfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Date',
                  value: DateTimeUtils.formatFullDate(startsAt),
                ),
                InfoRow(
                  icon: Icons.access_time_rounded,
                  label: 'Time',
                  value: DateTimeUtils.formatSlotTime(startsAt),
                ),
              ],
              InfoRow(
                icon: Icons.timelapse_rounded,
                label: 'Duration',
                value: DateTimeUtils.formatDuration(
                  schedule.totalDurationMinutes,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.5.h),
        PaymentCard(payment: details.payment),
        if (details.actions.any) ...[
          SizedBox(height: 1.5.h),
          ManageBookingCard(
            actions: details.actions,
            hasReviewed: booking.hasReviewed,
            onReschedule: onReschedule,
            // TODO: wire to the cancel API once it is specified.
            onCancel: () {},
            // TODO: open the review flow once it is specified.
            onReview: () {},
          ),
        ],
        SizedBox(height: 1.5.h),
      ],
    );
  }
}

class _BookingDetailsMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _BookingDetailsMessage({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    // Kept scrollable so pull-to-refresh still works on failure.
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => onRetry(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 15.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          SizedBox(height: 1.5.h),
          Center(
            child: TextButton(onPressed: onRetry, child: const Text('Retry')),
          ),
        ],
      ),
    );
  }
}
