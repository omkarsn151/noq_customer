import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/features/bookings/bloc/cancel_booking_bloc.dart';
import 'package:noq/features/bookings/bloc/cancel_booking_event.dart';
import 'package:noq/features/bookings/presentation/widgets/cancel_booking_sheet.dart';

/// Collects the optional reason, then hands the request to [CancelBookingBloc].
/// Returns without dispatching if the sheet is dismissed. The result is not
/// awaited here; screens react through `CancelBookingListener`.
Future<void> runCancelBooking(
  BuildContext context, {
  required String bookingId,
}) async {
  // Read before the await: the sheet's context may be gone afterwards.
  final bloc = context.read<CancelBookingBloc>();
  final note = await CancelBookingSheet.show(context);
  if (note == null) return;
  bloc.add(
    CancelBookingRequested(
      bookingId: bookingId,
      reason: note.isEmpty ? null : note,
    ),
  );
}
