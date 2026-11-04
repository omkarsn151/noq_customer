import 'package:flutter_test/flutter_test.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/features/business_list/data/business_list_model.dart';
import 'package:noq/features/favorites/bloc/favorites_list_bloc.dart';
import 'package:noq/features/favorites/bloc/favorites_list_event.dart';
import 'package:noq/features/favorites/bloc/favorites_list_state.dart';
import 'package:noq/features/favorites/repository/favorites_repository.dart';

/// Pages through [saved] the way the server does, so a removal shifts later
/// shops up exactly as it would in production.
class _FakeFavoritesRepository implements FavoritesRepository {
  final List<String> saved;

  _FakeFavoritesRepository(this.saved);

  @override
  Future<PaginatedResponse<BusinessListModel>> getFavorites({
    int page = 1,
    int pageSize = FavoritesRepository.defaultPageSize,
  }) async {
    final start = (page - 1) * pageSize;
    return PaginatedResponse(
      items: saved.skip(start).take(pageSize).map(_shop).toList(),
      meta: PageMeta(
        page: page,
        pageSize: pageSize,
        totalItems: saved.length,
        totalPages: (saved.length / pageSize).ceil(),
      ),
    );
  }

  @override
  Future<String> addFavorite(String businessId) async => '';

  @override
  Future<String> removeFavorite(String businessId) async => '';
}

BusinessListModel _shop(String id) => BusinessListModel(
  id: id,
  name: id,
  thumbnailUrl: null,
  services: const [],
  pricing: null,
  rating: const BusinessListRating(average: 0, totalReviews: 0),
  waitMinutes: null,
  address: null,
  distanceKm: null,
  isFavorited: true,
);

List<String> _ids(int count) => [for (var i = 0; i < count; i++) 'shop-$i'];

void main() {
  group('FavoritesListBloc', () {
    Future<FavoritesListBloc> loadedBloc(List<String> saved) async {
      final bloc = FavoritesListBloc(_FakeFavoritesRepository(saved))
        ..add(const FavoritesListRequested());
      await pumpEventQueue();
      return bloc;
    }

    Future<void> remove(
      FavoritesListBloc bloc,
      List<String> saved,
      String id,
    ) async {
      saved.remove(id);
      bloc.add(FavoritesListItemChanged(businessId: id, isFavorited: false));
      await pumpEventQueue();
    }

    List<String> loadedIds(FavoritesListBloc bloc) =>
        bloc.state.businesses.map((item) => item.id).toList();

    test('an empty list is a success with nothing more to load', () async {
      final bloc = await loadedBloc([]);

      expect(bloc.state.status, FavoritesListStatus.success);
      expect(bloc.state.businesses, isEmpty);
      expect(bloc.state.hasMore, isFalse);
      await bloc.close();
    });

    test('appends the next page', () async {
      final saved = _ids(25);
      final bloc = await loadedBloc(saved);
      expect(bloc.state.businesses, hasLength(20));

      bloc.add(const FavoritesListNextPageRequested());
      await pumpEventQueue();

      expect(loadedIds(bloc), saved);
      expect(bloc.state.hasMore, isFalse);
      await bloc.close();
    });

    test('skips no shop and repeats none after a removal', () async {
      final saved = _ids(45);
      final bloc = await loadedBloc(saved);

      await remove(bloc, saved, 'shop-3');
      while (bloc.state.hasMore) {
        bloc.add(const FavoritesListNextPageRequested());
        await pumpEventQueue();
      }

      expect(loadedIds(bloc), saved);
      await bloc.close();
    });

    test('reloads when the last row goes but more pages remain', () async {
      final saved = _ids(21);
      final bloc = FavoritesListBloc(_FakeFavoritesRepository(saved))
        ..add(const FavoritesListRequested());
      await pumpEventQueue();

      for (final id in _ids(20)) {
        await remove(bloc, saved, id);
      }

      expect(loadedIds(bloc), ['shop-20']);
      await bloc.close();
    });

    test('reloads when a shop not on screen is saved again', () async {
      final saved = _ids(2);
      final bloc = await loadedBloc(saved);

      await remove(bloc, saved, 'shop-0');
      saved.insert(0, 'shop-0');
      bloc.add(
        const FavoritesListItemChanged(businessId: 'shop-0', isFavorited: true),
      );
      await pumpEventQueue();

      expect(loadedIds(bloc), ['shop-0', 'shop-1']);
      await bloc.close();
    });
  });
}
