import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:noq/core/services/location_service.dart';
import 'package:noq/features/home/bloc/home_bloc.dart';
import 'package:noq/features/home/bloc/home_event.dart';
import 'package:noq/features/home/bloc/home_state.dart';
import 'package:noq/features/home/data/home_model.dart';
import 'package:noq/features/home/repository/home_repository.dart';

/// Records each call's coordinates. Fails every call from [failFromCall] on.
class _FakeHomeRepository implements HomeRepository {
  final List<double?> requestedLats = [];
  int? failFromCall;

  @override
  Future<HomeModel> getHome({double? lat, double? lng}) async {
    requestedLats.add(lat);
    if (failFromCall != null && requestedLats.length >= failFromCall!) {
      throw Exception('offline');
    }
    return HomeModel.fromJson(const {});
  }
}

/// [refresh] stays pending until the test completes it.
class _FakeLocationService implements LocationService {
  final SavedLocation? saved;
  final refresh = Completer<SavedLocation?>();

  _FakeLocationService({this.saved});

  @override
  Future<SavedLocation?> getSavedLocation() async => saved;

  @override
  Future<SavedLocation?> refreshLocation() => refresh.future;

  @override
  Future<void> clear() async {}
}

// 0.01 degrees of latitude is about 1.1 km.
const _saved = SavedLocation(latitude: 12.0, longitude: 77.0);
const _nearby = SavedLocation(latitude: 12.001, longitude: 77.0);
const _farAway = SavedLocation(latitude: 12.01, longitude: 77.0);

void main() {
  group('HomeBloc location', () {
    late _FakeHomeRepository repository;

    Future<HomeBloc> loadedBloc(_FakeLocationService location) async {
      final bloc = HomeBloc(repository, location)..add(const HomeRequested());
      await pumpEventQueue();
      return bloc;
    }

    setUp(() => repository = _FakeHomeRepository());

    test('a saved position loads without waiting for GPS', () async {
      final bloc = await loadedBloc(_FakeLocationService(saved: _saved));

      expect(bloc.state, isA<HomeLoaded>());
      expect(repository.requestedLats, [12.0]);
      await bloc.close();
    });

    test('moving past the distance reloads with the new position', () async {
      final location = _FakeLocationService(saved: _saved);
      final bloc = await loadedBloc(location);
      final first = bloc.state;

      location.refresh.complete(_farAway);
      await pumpEventQueue();

      expect(repository.requestedLats, [12.0, 12.01]);
      expect(bloc.state, isA<HomeLoaded>());
      expect(bloc.state, isNot(first));
      await bloc.close();
    });

    test('moving a short way does not reload', () async {
      final location = _FakeLocationService(saved: _saved);
      final bloc = await loadedBloc(location);

      location.refresh.complete(_nearby);
      await pumpEventQueue();

      expect(repository.requestedLats, [12.0]);
      await bloc.close();
    });

    test('turning location off reloads without coordinates', () async {
      final location = _FakeLocationService(saved: _saved);
      final bloc = await loadedBloc(location);

      location.refresh.complete(null);
      await pumpEventQueue();

      expect(repository.requestedLats, [12.0, null]);
      await bloc.close();
    });

    test('with nothing saved it waits for GPS once', () async {
      final location = _FakeLocationService();
      final bloc = await loadedBloc(location);

      expect(bloc.state, isA<HomeLoading>());
      expect(repository.requestedLats, isEmpty);

      location.refresh.complete(_saved);
      await pumpEventQueue();

      expect(bloc.state, isA<HomeLoaded>());
      expect(repository.requestedLats, [12.0]);
      await bloc.close();
    });

    test('a failed background reload keeps the loaded page', () async {
      final location = _FakeLocationService(saved: _saved);
      repository.failFromCall = 2;
      final bloc = await loadedBloc(location);
      final first = bloc.state;

      location.refresh.complete(_farAway);
      await pumpEventQueue();

      expect(repository.requestedLats, [12.0, 12.01]);
      expect(bloc.state, first);
      await bloc.close();
    });
  });
}
