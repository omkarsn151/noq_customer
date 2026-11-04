import 'package:flutter_test/flutter_test.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/core/services/recent_searches_service.dart';
import 'package:noq/features/search/bloc/search_bloc.dart';
import 'package:noq/features/search/bloc/search_event.dart';
import 'package:noq/features/search/bloc/search_state.dart';
import 'package:noq/features/search/data/quick_filter_model.dart';
import 'package:noq/features/search/data/search_result_model.dart';
import 'package:noq/features/search/data/search_service_model.dart';
import 'package:noq/features/search/repository/search_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Records every search and echoes the query back, as the server does.
class _FakeSearchRepository implements SearchRepository {
  final searches = <String>[];

  /// Per-query reply delay, to make responses arrive out of order.
  final delays = <String, Duration>{};

  /// Per-query error to throw instead of replying.
  final errors = <String, Object>{};

  bool failQuickFilters = false;

  @override
  Future<List<QuickFilterModel>> getQuickFilters() async {
    if (failQuickFilters) throw const ApiException('Server down');
    return const [
      QuickFilterModel(label: 'Haircuts', categoryId: 'c', businessCount: 3),
    ];
  }

  @override
  Future<SearchResultModel> search(String q) async {
    searches.add(q);
    await Future<void>.delayed(delays[q] ?? Duration.zero);
    final error = errors[q];
    if (error != null) throw error;
    return SearchResultModel.fromJson({
      'query': q,
      'businesses': {
        'total': 1,
        'items': [
          {'id': 'shop-1', 'is_favorited': false},
        ],
      },
    });
  }

  @override
  Future<PaginatedResponse<SearchServiceItem>> searchServices({
    required String q,
    int page = 1,
    int pageSize = SearchRepository.defaultPageSize,
  }) => throw UnimplementedError();
}

/// Comfortably past the debounce.
Future<void> _settle() => Future<void>.delayed(SearchBloc.debounceDuration * 2);

void main() {
  late _FakeSearchRepository repository;
  late SearchBloc bloc;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = _FakeSearchRepository();
    bloc = SearchBloc(repository, RecentSearchesService());
  });

  tearDown(() => bloc.close());

  group('typing', () {
    test('under 2 characters stays idle and makes no call', () async {
      bloc.add(const SearchQueryChanged(' h '));
      await _settle();

      expect(repository.searches, isEmpty);
      expect(bloc.state.isIdle, isTrue);
    });

    test('fast typing is debounced into one search', () async {
      for (final text in ['ha', 'hai', 'hair']) {
        bloc.add(SearchQueryChanged(text));
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
      await _settle();

      expect(repository.searches, ['hair']);
      expect(bloc.state.status, SearchStatus.success);
      expect(bloc.state.result?.query, 'hair');
    });

    test(
      'a slow reply for an older query never replaces a newer one',
      () async {
        repository.delays['hai'] = const Duration(milliseconds: 500);

        bloc.add(const SearchQueryChanged('hai'));
        await _settle(); // 'hai' is now in flight
        bloc.add(const SearchQueryChanged('hair'));
        await Future<void>.delayed(const Duration(milliseconds: 800));

        expect(repository.searches, ['hai', 'hair']);
        expect(bloc.state.query, 'hair');
        expect(bloc.state.result?.query, 'hair');
      },
    );

    test('clearing cancels a search still waiting on the debounce', () async {
      bloc.add(const SearchQueryChanged('hair'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      bloc.add(const SearchCleared());
      await _settle();

      expect(repository.searches, isEmpty);
      expect(bloc.state.isIdle, isTrue);
      expect(bloc.state.result, isNull);
    });
  });

  group('errors', () {
    test('VALIDATION_ERROR ends quietly, without a failure', () async {
      repository.errors['hair'] = const ApiException(
        'Invalid',
        statusCode: 422,
        code: 'VALIDATION_ERROR',
      );

      bloc.add(const SearchSubmitted('hair'));
      await pumpEventQueue();

      expect(bloc.state.status, SearchStatus.initial);
      expect(bloc.state.result, isNull);
      expect(bloc.state.message, isEmpty);
    });

    test('other errors fail with the server message', () async {
      repository.errors['hair'] = const ApiException('No internet connection.');

      bloc.add(const SearchSubmitted('hair'));
      await pumpEventQueue();

      expect(bloc.state.status, SearchStatus.failure);
      expect(bloc.state.message, 'No internet connection.');
    });
  });

  group('submitting', () {
    test('searches at once and saves the query to recents', () async {
      bloc.add(const SearchSubmitted(' hair '));
      await pumpEventQueue();

      expect(repository.searches, ['hair']);
      expect(bloc.state.recentSearches, ['hair']);
    });

    test('does not repeat a search already on screen', () async {
      bloc.add(const SearchSubmitted('hair'));
      await pumpEventQueue();
      // Opening a result submits the same query again.
      bloc.add(const SearchSubmitted('hair'));
      await pumpEventQueue();

      expect(repository.searches, ['hair']);
    });

    test('submit before the debounce runs out searches once', () async {
      bloc.add(const SearchQueryChanged('hair'));
      bloc.add(const SearchSubmitted('hair'));
      await _settle();

      expect(repository.searches, ['hair']);
    });
  });

  group('recent searches', () {
    test('loaded on start, removed and cleared', () async {
      await RecentSearchesService().add('spa');
      await RecentSearchesService().add('hair');

      bloc.add(const SearchStarted());
      await pumpEventQueue();
      expect(bloc.state.recentSearches, ['hair', 'spa']);

      bloc.add(const RecentSearchRemoved('hair'));
      await pumpEventQueue();
      expect(bloc.state.recentSearches, ['spa']);

      bloc.add(const RecentSearchesCleared());
      await pumpEventQueue();
      expect(bloc.state.recentSearches, isEmpty);
    });
  });

  group('quick filters', () {
    test('loaded on start', () async {
      bloc.add(const SearchStarted());
      await pumpEventQueue();

      expect(bloc.state.quickFiltersStatus, QuickFiltersStatus.success);
      expect(bloc.state.quickFilters.single.label, 'Haircuts');
    });

    test('a failure does not block search', () async {
      repository.failQuickFilters = true;

      bloc.add(const SearchStarted());
      await pumpEventQueue();
      bloc.add(const SearchSubmitted('hair'));
      await pumpEventQueue();

      expect(bloc.state.quickFiltersStatus, QuickFiltersStatus.failure);
      expect(bloc.state.status, SearchStatus.success);
    });
  });

  test('a favourite change patches the shop without searching again', () async {
    bloc.add(const SearchSubmitted('hair'));
    await pumpEventQueue();

    bloc.add(
      const SearchFavoriteChanged(businessId: 'shop-1', isFavorited: true),
    );
    await pumpEventQueue();

    expect(bloc.state.result?.businesses.items.single.isFavorited, isTrue);
    expect(repository.searches, ['hair']);
  });
}
