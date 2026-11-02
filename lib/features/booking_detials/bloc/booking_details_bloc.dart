import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/core/services/location_service.dart';
import 'package:noq/features/booking_detials/bloc/booking_details_event.dart';
import 'package:noq/features/booking_detials/bloc/booking_details_state.dart';
import 'package:noq/features/booking_detials/repository/booking_details_repository.dart';

class BookingDetailsBloc
    extends Bloc<BookingDetailsEvent, BookingDetailsState> {
  final BookingDetailsRepository _repository;
  final LocationService _locationService;

  BookingDetailsBloc(this._repository, this._locationService)
    : super(const BookingDetailsState()) {
    on<BookingDetailsRequested>(_onRequested);
  }

  Future<void> _onRequested(
    BookingDetailsRequested event,
    Emitter<BookingDetailsState> emit,
  ) async {
    emit(
      BookingDetailsState(
        status: BookingDetailsStatus.loading,
        bookingId: event.bookingId,
      ),
    );

    try {
      // Null until Home has a position — the call then goes out without
      // coordinates and only distance_km comes back null.
      final position = await _locationService.getSavedLocation();
      final details = await _repository.getBookingDetails(
        event.bookingId,
        lat: position?.latitude,
        lng: position?.longitude,
      );
      // The screen moved on to another booking meanwhile — drop the result.
      if (state.bookingId != event.bookingId) return;
      emit(
        state.copyWith(status: BookingDetailsStatus.success, details: details),
      );
    } catch (e) {
      if (state.bookingId != event.bookingId) return;
      emit(
        state.copyWith(
          status: _isNotFound(e)
              ? BookingDetailsStatus.notFound
              : BookingDetailsStatus.failure,
          message: _messageOf(e),
        ),
      );
    }
  }

  bool _isNotFound(Object error) =>
      error is ApiException && error.code == 'BOOKING_NOT_FOUND';

  String _messageOf(Object error) =>
      error is ApiException ? error.message : error.toString();
}
