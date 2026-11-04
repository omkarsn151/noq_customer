import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/core/utils/date_time_utils.dart';
import 'package:noq/features/bookings/bloc/bookings_bloc.dart';
import 'package:noq/features/bookings/bloc/bookings_event.dart';
import 'package:noq/features/bookings/data/booking_rescheduled_model.dart';
import 'package:noq/features/bookings/data/booking_tab.dart';
import 'package:noq/features/cart/bloc/cart_bloc.dart';
import 'package:noq/features/cart/bloc/cart_event.dart';
import 'package:noq/features/slot/bloc/slot_bloc.dart';
import 'package:noq/features/slot/bloc/slot_event.dart';
import 'package:noq/features/slot/bloc/slot_state.dart';
import 'package:noq/features/slot/presentation/widgets/slot_content.dart';
import 'package:noq/features/slot/presentation/widgets/slots_loading_widget.dart';
import 'package:sizer/sizer.dart';

class SlotScreen extends StatefulWidget {
  /// Cart mode: book a new visit at this shop.
  final String? businessId;

  /// Reschedule mode: move this booking. Exactly one of the two is set.
  final String? rescheduleBookingId;

  const SlotScreen({super.key, required String this.businessId})
    : rescheduleBookingId = null;

  const SlotScreen.reschedule({super.key, required String bookingId})
    : businessId = null,
      rescheduleBookingId = bookingId;

  bool get isReschedule => rescheduleBookingId != null;

  @override
  State<SlotScreen> createState() => _SlotScreenState();
}

class _SlotScreenState extends State<SlotScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SlotBloc>().add(
      widget.isReschedule
          ? SlotRescheduleRequested(widget.rescheduleBookingId!)
          : SlotRequested(widget.businessId!),
    );
  }

  void _rescheduleListener(BuildContext context, SlotLoaded state) {
    final result = state.rescheduled;
    if (result != null) {
      // Branch on the outcome only: for a pending request `scheduledStart` is
      // still the old time, so comparing times would misread it as moved.
      switch (result.outcome) {
        case RescheduleOutcome.moved:
          AppSnackbar.success(
            context,
            result.message.isEmpty
                ? 'Your booking has been rescheduled.'
                : result.message,
          );
          context.pop(true);
        case RescheduleOutcome.requestPending:
          final asked = result.proposedStart;
          AppSnackbar.info(
            context,
            asked == null
                ? result.message
                : 'Request sent to ${state.model.business.name} for '
                      '${DateTimeUtils.formatBookingDateTime(asked)}. '
                      'Your booking stays at its current time until they '
                      'respond.',
          );
          context.pop(true);
        case RescheduleOutcome.unchanged:
          // The API asks for no toast: nothing changed.
          context.pop(false);
      }
      return;
    }

    final error = state.submitError;
    if (error != null) {
      AppSnackbar.error(context, error);
      // The booking itself can't be moved any more; `true` tells the caller to
      // refresh. Every other failure has already reloaded the grid.
      if (state.isBookingInvalid) context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SlotBloc, SlotState>(
      listenWhen: (previous, current) {
        if (previous is! SlotLoaded || current is! SlotLoaded) return false;
        return previous.submitError != current.submitError ||
            previous.createdBooking != current.createdBooking ||
            previous.rescheduled != current.rescheduled;
      },
      listener: (context, state) {
        if (state is! SlotLoaded) return;

        if (widget.isReschedule) {
          _rescheduleListener(context, state);
          return;
        }

        final booking = state.createdBooking;
        if (booking != null) {
          // The create call consumed the cart, so pull the empty one to clear
          // the Cart tab and its sticky bar.
          context.read<CartBloc>().add(CartItemsRequested());
          // The Bookings tab stays alive in the shell, so it won't reload the
          // new booking on its own.
          context.read<BookingsBloc>().add(
            BookingsRefreshRequested(tab: BookingTab.values.first),
          );
          // Replace rather than push: going back to a slot grid for a cart that
          // no longer exists would only produce CART_EMPTY. This must be a
          // router route: a raw Navigator route sits on top of the shell, out
          // of go_router's reach, so `context.go` could not leave it.
          context.pushReplacement('/booking-success', extra: booking);
          return;
        }

        final error = state.submitError;
        if (error != null) {
          AppSnackbar.error(context, error);
          // Nothing here can recover a cart that emptied or changed shop; the
          // bloc has already reloaded the grid for every other failure.
          if (state.isCartInvalid) Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final businessName = state is SlotLoaded
            ? state.model.business.name
            : null;

        return Scaffold(
          appBar: AppAppBar(
            title: widget.isReschedule ? 'Reschedule Booking' : 'Service Slot',
            subtitle: (businessName?.isEmpty ?? true) ? null : businessName,
          ),
          body: switch (state) {
            SlotFailure() => Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    // The booking may have changed between the tap and the
                    // load; leaving with `true` makes the caller refresh.
                    if (widget.isReschedule) ...[
                      SizedBox(height: 2.h),
                      OutlinedButton(
                        onPressed: () => context.pop(true),
                        child: const Text('Go back'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SlotLoaded() => SlotContent(
              state: state,
              isReschedule: widget.isReschedule,
            ),
            _ => SlotsLoadingWidget(isReschedule: widget.isReschedule),
          },
        );
      },
    );
  }
}
