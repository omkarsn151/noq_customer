import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/business_details/bloc/business_details_event.dart';
import 'package:noq/features/business_details/bloc/business_details_state.dart';
import 'package:noq/features/business_details/repository/business_details_repository.dart';

class BusinessDetailsBloc
    extends Bloc<BusinessDetailsEvent, BusinessDetailsState> {
  final BusinessDetailsRepository _repository;

  BusinessDetailsBloc(this._repository) : super(const BusinessDetailsInitial()) {
    on<BusinessDetailsRequested>(_onBusinessDetailsRequested);
  }

  Future<void> _onBusinessDetailsRequested(
    BusinessDetailsRequested event,
    Emitter<BusinessDetailsState> emit,
  ) async {
    emit(const BusinessDetailsLoading());
    try {
      final details = await _repository.getBusinessDetails(event.businessId);
      emit(BusinessDetailsLoaded(details: details));
    } on ApiException catch (e) {
      emit(BusinessDetailsFailure(message: e.message));
    } catch (e) {
      emit(BusinessDetailsFailure(message: e.toString()));
    }
  }
}
