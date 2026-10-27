import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/business_details/bloc/business_details_event.dart';
import 'package:noq/features/business_details/bloc/business_details_state.dart';
import 'package:noq/features/business_details/repository/business_details_repository.dart';

class BusinessDetailsBloc
    extends Bloc<BusinessDetailsEvent, BusinessDetailsState> {
  final BusinessDetailsRepository _repository;

  BusinessDetailsBloc(this._repository)
    : super(const BusinessDetailsInitial()) {
    on<BusinessDetailsRequested>(_onBusinessDetailsRequested);
  }

  Future<void> _onBusinessDetailsRequested(
    BusinessDetailsRequested event,
    Emitter<BusinessDetailsState> emit,
  ) async {
    final current = state;
    final isSilent =
        event.silent &&
        current is BusinessDetailsLoaded &&
        current.details.id == event.businessId;

    if (!isSilent) emit(const BusinessDetailsLoading());
    try {
      final details = await _repository.getBusinessDetails(event.businessId);
      // Another business was opened meanwhile — drop the background result.
      if (isSilent && !_isShowing(event.businessId)) return;
      emit(BusinessDetailsLoaded(details: details));
    } on ApiException catch (e) {
      // Keep the page as it is; the next full load will surface the error.
      if (isSilent) return;
      if (e.code == 'CUSTOMER_BUSINESS_NOT_FOUND') {
        emit(BusinessDetailsNotFound(businessId: event.businessId));
      } else {
        emit(BusinessDetailsFailure(message: e.message));
      }
    } catch (e) {
      if (isSilent) return;
      emit(BusinessDetailsFailure(message: e.toString()));
    }
  }

  bool _isShowing(String businessId) {
    final current = state;
    return current is BusinessDetailsLoaded && current.details.id == businessId;
  }
}
