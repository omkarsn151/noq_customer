import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/core/services/location_service.dart';
import 'package:noq/features/business_list/bloc/business_list_event.dart';
import 'package:noq/features/business_list/bloc/business_list_state.dart';
import 'package:noq/features/business_list/repository/business_list_repository.dart';

class BusinessListBloc extends Bloc<BusinessListEvent, BusinessListState> {
  final BusinessListRepository _repository;
  final LocationService _locationService;

  BusinessListBloc(this._repository, this._locationService)
    : super(const BusinessListState()) {
    on<BusinessListRequested>(_onBusinessListRequested);
    on<BusinessListNextPageRequested>(_onNextPageRequested);
  }

  Future<void> _onBusinessListRequested(
    BusinessListRequested event,
    Emitter<BusinessListState> emit,
  ) async {
    // Start from a clean state so another category's shops never flash up.
    emit(
      BusinessListState(
        status: BusinessListStatus.loading,
        categoryId: event.categoryId,
      ),
    );

    try {
      // Null when GPS is off or denied — the list is then best-rated first.
      final position = await _locationService.getCurrentPosition();
      final page = await _repository.getBusinesses(
        categoryId: event.categoryId,
        lat: position?.latitude,
        lng: position?.longitude,
      );
      emit(
        BusinessListState(
          status: BusinessListStatus.success,
          businesses: page.items,
          meta: page.meta,
          categoryId: event.categoryId,
          lat: position?.latitude,
          lng: position?.longitude,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BusinessListStatus.failure,
          message: _messageOf(e),
        ),
      );
    }
  }

  Future<void> _onNextPageRequested(
    BusinessListNextPageRequested event,
    Emitter<BusinessListState> emit,
  ) async {
    if (state.isLoadingMore ||
        !state.hasMore ||
        state.status != BusinessListStatus.success) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    try {
      final page = await _repository.getBusinesses(
        categoryId: state.categoryId,
        lat: state.lat,
        lng: state.lng,
        page: state.meta.page + 1,
      );
      emit(
        state.copyWith(
          businesses: [...state.businesses, ...page.items],
          meta: page.meta,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      // Keep the loaded pages on screen and surface the message inline.
      emit(state.copyWith(isLoadingMore: false, message: _messageOf(e)));
    }
  }

  String _messageOf(Object error) =>
      error is ApiException ? error.message : error.toString();
}
