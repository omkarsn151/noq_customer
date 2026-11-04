import 'package:flutter_test/flutter_test.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/features/search/bloc/search_services_bloc.dart';
import 'package:noq/features/search/bloc/search_services_event.dart';
import 'package:noq/features/search/bloc/search_services_state.dart';
import 'package:noq/features/search/data/quick_filter_model.dart';
import 'package:noq/features/search/data/search_result_model.dart';
import 'package:noq/features/search/data/search_service_model.dart';
import 'package:noq/features/search/repository/search_repository.dart';

/// Serves [totalPages] one-service pages; [failingPages] throw once each.
class _FakeSearchRepository implements SearchRepository {
  final int totalPages;
  final Set<int> failingPages;
  final requests = <({String q, int page})>[];

  _FakeSearchRepository({required this.totalPages, Set<int>? failingPages})
    : failingPages = failingPages ?? {};

  @override
  Future<PaginatedResponse<SearchServiceItem>> searchServices({
    required String q,
    int page = 1,
    int pageSize = SearchRepository.defaultPageSize,
  }) async {
    requests.add((q: q, page: page));
    if (failingPages.remove(page)) throw const ApiException('Timed out');
    return PaginatedResponse(
      items: [
        SearchServiceItem.fromJson({'id': 'svc-$page'}),
      ],
      meta: PageMeta(
        page: page,
        pageSize: pageSize,
        totalItems: totalPages,
        totalPages: totalPages,
      ),
    );
  }

  @override
  Future<List<QuickFilterModel>> getQuickFilters() =>
      throw UnimplementedError();

  @override
  Future<SearchResultModel> search(String q) => throw UnimplementedError();
}

void main() {
  Future<SearchServicesBloc> loadedBloc(
    _FakeSearchRepository repository,
  ) async {
    final bloc = SearchServicesBloc(repository)
      ..add(const SearchServicesRequested('hair'));
    await pumpEventQueue();
    return bloc;
  }

  Future<void> nextPage(SearchServicesBloc bloc) async {
    bloc.add(const SearchServicesNextPageRequested());
    await pumpEventQueue();
  }

  List<String> ids(SearchServicesBloc bloc) =>
      bloc.state.services.map((s) => s.id).toList();

  test('pages until page == total_pages, keeping the query', () async {
    final repository = _FakeSearchRepository(totalPages: 2);
    final bloc = await loadedBloc(repository);

    expect(bloc.state.hasMore, isTrue);
    await nextPage(bloc);
    expect(ids(bloc), ['svc-1', 'svc-2']);
    expect(bloc.state.hasMore, isFalse);

    await nextPage(bloc); // already at the end: no request
    expect(repository.requests, [(q: 'hair', page: 1), (q: 'hair', page: 2)]);
  });

  test('a failed next page keeps the loaded rows and can be retried', () async {
    final repository = _FakeSearchRepository(totalPages: 2, failingPages: {2});
    final bloc = await loadedBloc(repository);

    await nextPage(bloc);
    expect(bloc.state.status, SearchServicesStatus.success);
    expect(ids(bloc), ['svc-1']);
    expect(bloc.state.message, 'Timed out');

    await nextPage(bloc);
    expect(ids(bloc), ['svc-1', 'svc-2']);
    // Cleared, so the screen doesn't report the old error again.
    expect(bloc.state.message, isEmpty);
  });

  test('a failed first page is a failure', () async {
    final repository = _FakeSearchRepository(totalPages: 1, failingPages: {1});
    final bloc = await loadedBloc(repository);

    expect(bloc.state.status, SearchServicesStatus.failure);
    expect(bloc.state.message, 'Timed out');
  });
}
