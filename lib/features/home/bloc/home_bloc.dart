import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/core/services/location_service.dart';
import 'package:noq/features/home/bloc/home_event.dart';
import 'package:noq/features/home/bloc/home_state.dart';
import 'package:noq/features/home/data/home_model.dart';
import 'package:noq/features/home/repository/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  /// How far the customer must move before Home reloads on its own.
  static const double _reloadDistanceMeters = 500;

  final HomeRepository _repository;
  final LocationService _locationService;

  HomeBloc(this._repository, this._locationService)
    : super(const HomeInitial()) {
    on<HomeRequested>(_onHomeRequested);
    on<HomeFavoriteChanged>(_onFavoriteChanged);
  }

  void _onFavoriteChanged(HomeFavoriteChanged event, Emitter<HomeState> emit) {
    final current = state;
    if (current is! HomeLoaded) return;
    final nearby = current.home.nearby;
    emit(
      HomeLoaded(
        home: current.home.copyWith(
          nearby: nearby.copyWith(
            items: [
              for (final item in nearby.items)
                item.id == event.businessId
                    ? item.copyWith(isFavorited: event.isFavorited)
                    : item,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onHomeRequested(
    HomeRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    try {
      // A saved position loads straight away; only the first run waits on GPS.
      // Null when GPS is off or denied — the call then goes out without
      // coordinates and nearby shops come back best-rated first.
      final saved = await _locationService.getSavedLocation();
      final position = saved ?? await _locationService.refreshLocation();
      emit(HomeLoaded(home: await _getHome(position)));
      if (saved != null) await _refreshIfMoved(saved, emit);
    } on ApiException catch (e) {
      emit(HomeFailure(message: e.message));
    } catch (e) {
      emit(HomeFailure(message: e.toString()));
    }
  }

  /// Updates the saved position behind the loaded page, reloading it without a
  /// spinner only if the nearby shops would change.
  Future<void> _refreshIfMoved(
    SavedLocation saved,
    Emitter<HomeState> emit,
  ) async {
    final current = await _locationService.refreshLocation();
    if (!_hasMoved(saved, current)) return;

    try {
      final home = await _getHome(current);
      // A pull-to-refresh started meanwhile — leave its spinner alone.
      if (state is HomeLoaded) emit(HomeLoaded(home: home));
    } catch (_) {
      // Keep the page as it is; the next load will surface the error.
    }
  }

  bool _hasMoved(SavedLocation saved, SavedLocation? current) {
    if (current == null) return true;
    final meters = Geolocator.distanceBetween(
      saved.latitude,
      saved.longitude,
      current.latitude,
      current.longitude,
    );
    return meters > _reloadDistanceMeters;
  }

  Future<HomeModel> _getHome(SavedLocation? position) => _repository.getHome(
    lat: position?.latitude,
    lng: position?.longitude,
  );
}
