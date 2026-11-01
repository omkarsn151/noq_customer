import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/bookings/bloc/cancel_booking_event.dart';
import 'package:noq/features/bookings/bloc/cancel_booking_state.dart';
import 'package:noq/features/bookings/repository/bookings_repository.dart';

class CancelBookingBloc extends Bloc<CancelBookingEvent, CancelBookingState> {
  final BookingsRepository _repository;

  /// Bookings with a cancel in flight; further requests for them are ignored.
  final Set<String> _pending = {};

  CancelBookingBloc(this._repository) : super(const CancelBookingInitial()) {
    on<CancelBookingRequested>(_onCancelBookingRequested);
  }

  Future<void> _onCancelBookingRequested(
    CancelBookingRequested event,
    Emitter<CancelBookingState> emit,
  ) async {
    final bookingId = event.bookingId;
    if (!_pending.add(bookingId)) return;

    emit(CancelBookingInProgress(bookingId: bookingId));
    try {
      final result = await _repository.cancelBooking(
        bookingId,
        reason: event.reason,
      );
      emit(CancelBookingSuccess(bookingId: bookingId, result: result));
    } on ApiException catch (e) {
      emit(
        CancelBookingFailure(
          bookingId: bookingId,
          message: e.message,
          code: e.code,
        ),
      );
    } catch (e) {
      emit(CancelBookingFailure(bookingId: bookingId, message: e.toString()));
    } finally {
      _pending.remove(bookingId);
      // Back to Initial so an identical later result (a repeat cancel returns
      // the same body) is still a new state that listeners receive.
      emit(const CancelBookingInitial());
    }
  }
}
