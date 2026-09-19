import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/business/bloc/business_event.dart';
import 'package:noq/features/business/bloc/business_state.dart';
import 'package:noq/features/business/respository/business_repository.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  final BusinessRepository _repository;

  BusinessBloc(this._repository) : super(const BusinessInitial()) {
    on<BusinessListRequested>(_onBusinessListRequested);
  }

  Future<void> _onBusinessListRequested(
    BusinessListRequested event,
    Emitter<BusinessState> emit,
  ) async {
    emit(const BusinessLoading());
    try {
      final businesses = await _repository.getBusinessList();
      emit(BusinessLoaded(businesses: businesses));
    } on ApiException catch (e) {
      emit(BusinessFailure(message: e.message));
    } catch (e) {
      emit(BusinessFailure(message: e.toString()));
    }
  }
}
