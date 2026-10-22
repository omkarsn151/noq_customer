import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/core/services/location_service.dart';
import 'package:noq/features/home/bloc/home_event.dart';
import 'package:noq/features/home/bloc/home_state.dart';
import 'package:noq/features/home/repository/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;
  final LocationService _locationService;

  HomeBloc(this._repository, this._locationService)
    : super(const HomeInitial()) {
    on<HomeRequested>(_onHomeRequested);
  }

  Future<void> _onHomeRequested(
    HomeRequested event,
    Emitter<HomeState> emit,
  ) async {
    if (!event.refresh || state is! HomeLoaded) {
      emit(const HomeLoading());
    }

    try {
      // Null when GPS is off or denied — the call then goes out without
      // coordinates and nearby shops come back best-rated first.
      final position = await _locationService.getCurrentPosition();
      final home = await _repository.getHome(
        lat: position?.latitude,
        lng: position?.longitude,
      );
      emit(HomeLoaded(home: home));
    } on ApiException catch (e) {
      emit(HomeFailure(message: e.message));
    } catch (e) {
      emit(HomeFailure(message: e.toString()));
    }
  }
}
