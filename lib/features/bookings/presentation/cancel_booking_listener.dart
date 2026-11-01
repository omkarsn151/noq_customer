import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/features/bookings/bloc/bookings_bloc.dart';
import 'package:noq/features/bookings/bloc/bookings_event.dart';
import 'package:noq/features/bookings/bloc/cancel_booking_bloc.dart';
import 'package:noq/features/bookings/bloc/cancel_booking_state.dart';
import 'package:noq/features/bookings/data/booking_cancelled_model.dart';
import 'package:noq/features/bookings/data/booking_tab.dart';

/// Failures that mean our copy of the booking is out of date, so the screen
/// should reload rather than let the customer try again.
const Set<String> _staleCodes = {
  'BOOKING_CANNOT_CANCEL',
  'BOOKING_REQUEST_EXPIRED',
  'BOOKING_NOT_FOUND',
};

/// Reacts to results from the app-wide [CancelBookingBloc].
///
/// Every screen in the stack listens, so the snackbar is shown only by the
/// visible route; screens underneath just refresh via the callbacks.
class CancelBookingListener extends StatelessWidget {
  /// Whether this screen cares about [bookingId]. The list passes `(_) => true`;
  /// details passes `(id) => id == widget.bookingId`.
  final bool Function(String bookingId) isRelevant;

  /// After a successful cancel of a relevant booking.
  final void Function(BookingCancelledModel result)? onCancelled;

  /// After a failure that means our copy of the booking is stale.
  final VoidCallback? onStale;

  /// Whether this listener refreshes the bookings list. Only `BookingsScreen`
  /// sets it: it stays mounted under details, so one refresh is enough.
  final bool refreshList;

  final Widget child;

  const CancelBookingListener({
    super.key,
    required this.isRelevant,
    this.onCancelled,
    this.onStale,
    this.refreshList = false,
    required this.child,
  });

  bool _isVisible(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent ?? true;

  String _successMessage(BookingCancelledModel result) {
    final message = result.message.isEmpty
        ? 'Booking cancelled.'
        : result.message;
    if (!result.hasFee) return message;
    return '$message A late cancellation fee of '
        '${result.currencyCode} ${result.feeAmount} applies.';
  }

  void _refreshList(BuildContext context, BookingTab tab) {
    if (!refreshList) return;
    context.read<BookingsBloc>().add(BookingsRefreshRequested(tab: tab));
  }

  void _listener(BuildContext context, CancelBookingState state) {
    switch (state) {
      case CancelBookingSuccess(:final bookingId, :final result)
          when isRelevant(bookingId):
        if (_isVisible(context)) {
          AppSnackbar.success(context, _successMessage(result));
        }
        _refreshList(context, result.fromTab ?? BookingTab.upcoming);
        onCancelled?.call(result);
      case CancelBookingFailure(:final bookingId, :final message, :final code)
          when isRelevant(bookingId):
        if (_isVisible(context)) AppSnackbar.error(context, message);
        if (code != null && _staleCodes.contains(code)) {
          _refreshList(context, BookingTab.upcoming);
          onStale?.call();
        }
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CancelBookingBloc, CancelBookingState>(
      listener: _listener,
      child: child,
    );
  }
}
