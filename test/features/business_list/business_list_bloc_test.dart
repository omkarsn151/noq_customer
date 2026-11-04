import 'package:flutter_test/flutter_test.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/core/services/location_service.dart';
import 'package:noq/features/business_list/bloc/business_list_bloc.dart';
import 'package:noq/features/business_list/bloc/business_list_event.dart';
import 'package:noq/features/business_list/data/business_list_model.dart';
import 'package:noq/features/business_list/repository/business_list_repository.dart';

/// Serves two one-shop pages and records the filters of every request.
class _FakeBusinessListRepository implements BusinessListRepository {
  final requests = <({String? categoryId, String? q, double? lat, int page})>[];

  @override
  Future<PaginatedResponse<BusinessListModel>> getBusinesses({
    String? categoryId,
    String? q,
    double? lat,
    double? lng,
    int page = 1,
    int pageSize = BusinessListRepository.defaultPageSize,
  }) async {
    requests.add((categoryId: categoryId, q: q, lat: lat, page: page));
    return PaginatedResponse(
      items: [
        BusinessListModel.fromJson({'id': 'shop-$page'}),
      ],
      meta: PageMeta(
        page: page,
        pageSize: pageSize,
        totalItems: 2,
        totalPages: 2,
      ),
    );
  }
}

void main() {
  // Search lists only: a category list reads the saved location from secure
  // storage, which has no plugin in unit tests.
  test(
    '"See all shops" sends the query on every page, with no location',
    () async {
      final repository = _FakeBusinessListRepository();
      final bloc = BusinessListBloc(repository, LocationService())
        ..add(const BusinessListRequested(query: 'hair'));
      await pumpEventQueue();

      bloc.add(const BusinessListNextPageRequested());
      await pumpEventQueue();

      expect(repository.requests, [
        (categoryId: null, q: 'hair', lat: null, page: 1),
        (categoryId: null, q: 'hair', lat: null, page: 2),
      ]);
      expect(bloc.state.businesses.map((shop) => shop.id), [
        'shop-1',
        'shop-2',
      ]);
    },
  );
}
