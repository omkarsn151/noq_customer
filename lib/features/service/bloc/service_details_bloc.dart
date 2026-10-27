import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/service/bloc/service_details_event.dart';
import 'package:noq/features/service/bloc/service_details_state.dart';
import 'package:noq/features/service/repository/service_details_repository.dart';

class ServiceDetailsBloc
    extends Bloc<ServiceDetailsEvent, ServiceDetailsState> {
  final ServiceDetailsRepository _repository;

  ServiceDetailsBloc(this._repository) : super(const ServiceDetailsState()) {
    on<ServiceDetailsRequested>(_onRequested);
  }

  Future<void> _onRequested(
    ServiceDetailsRequested event,
    Emitter<ServiceDetailsState> emit,
  ) async {
    // Keep the loaded service on a reload of the same id (e.g. after a cart
    // change) so the screen does not blank out; start clean for a new one.
    final isReload =
        state.serviceId == event.serviceId && state.service != null;
    emit(
      ServiceDetailsState(
        status: isReload
            ? ServiceDetailsStatus.success
            : ServiceDetailsStatus.loading,
        service: isReload ? state.service : null,
        serviceId: event.serviceId,
      ),
    );

    try {
      final service = await _repository.getServiceDetails(
        businessId: event.businessId,
        serviceId: event.serviceId,
      );
      // The screen moved on to another service meanwhile — drop the result.
      if (state.serviceId != event.serviceId) return;
      emit(
        state.copyWith(status: ServiceDetailsStatus.success, service: service),
      );
    } catch (e) {
      if (state.serviceId != event.serviceId) return;
      emit(
        state.copyWith(
          status: _isNotFound(e)
              ? ServiceDetailsStatus.notFound
              : ServiceDetailsStatus.failure,
          message: _messageOf(e),
        ),
      );
    }
  }

  bool _isNotFound(Object error) =>
      error is ApiException &&
      (error.code == 'CUSTOMER_SERVICE_NOT_FOUND' ||
          error.code == 'CUSTOMER_BUSINESS_NOT_FOUND');

  String _messageOf(Object error) =>
      error is ApiException ? error.message : error.toString();
}
