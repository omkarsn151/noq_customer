import 'package:flutter_test/flutter_test.dart';
import 'package:noq/features/search/data/quick_filter_model.dart';
import 'package:noq/features/search/data/search_result_model.dart';

/// The `data` object of the search response sample in docs/customer-search.md.
Map<String, dynamic> _sample() => {
  'query': 'hair',
  'categories': {
    'total': 1,
    'items': [
      {
        'id': 'cat-1',
        'name': 'Haircuts',
        'subtitle': 'Quick trims',
        'image_url': 'https://example.com/c.png',
      },
    ],
  },
  'businesses': {
    'total': 12,
    'items': [
      {
        'id': 'shop-1',
        'name': 'Studio',
        'thumbnail_url': null,
        'services': ['Haircut'],
        'pricing': {
          'currency_code': 'INR',
          'min_price': '199.00',
          'max_price': '499.00',
        },
        'rating': {'average': 4.5, 'total_reviews': 10},
        'wait': null,
        'address': 'MG Road',
        'distance_km': null,
        'is_favorited': false,
      },
    ],
  },
  'services': {
    'total': 40,
    'items': [
      {
        'id': 'svc-1',
        'name': 'Classic Haircut',
        'duration_minutes': 30,
        'pricing': {'currency_code': 'INR', 'price': '499.00'},
        'thumbnail_url': null,
        'business': {'id': 'shop-1', 'name': 'Reliance & Elegance Studio'},
      },
    ],
  },
};

void main() {
  group('SearchResultModel', () {
    test('parses the documented sample', () {
      final result = SearchResultModel.fromJson(_sample());

      expect(result.query, 'hair');
      expect(result.isEmpty, isFalse);

      final category = result.categories.items.single;
      expect(category.name, 'Haircuts');
      expect(category.description, 'Quick trims');

      final shop = result.businesses.items.single;
      expect(shop.name, 'Studio');
      expect(shop.distanceKm, isNull);
      expect(shop.distanceLabel, isNull);

      final service = result.services.items.single;
      expect(service.durationMinutes, 30);
      expect(service.thumbnailUrl, isNull);
      expect(service.business.id, 'shop-1');
      expect(service.business.name, 'Reliance & Elegance Studio');
      // Money stays the server's decimal string.
      expect(service.pricing.price, '499.00');
      expect(service.pricing.label, '₹499.00');
    });

    test('"See all" is offered only when the preview is partial', () {
      final result = SearchResultModel.fromJson(_sample());

      expect(result.categories.hasMore, isFalse);
      expect(result.businesses.hasMore, isTrue);
      expect(result.services.hasMore, isTrue);
    });

    test('all-zero groups are an empty result, not an error', () {
      final result = SearchResultModel.fromJson({
        'query': 'zzz',
        'categories': {'total': 0, 'items': []},
        'businesses': {'total': 0, 'items': []},
        'services': {'total': 0, 'items': []},
      });

      expect(result.isEmpty, isTrue);
      expect(result.categories.hasMore, isFalse);
    });

    test('a missing group reads as empty', () {
      final result = SearchResultModel.fromJson({
        'query': 'hair',
        'categories': {'total': 0, 'items': []},
      });

      expect(result.businesses.isEmpty, isTrue);
      expect(result.businesses.items, isEmpty);
      expect(result.services.items, isEmpty);
    });

    test('null category subtitle and image are kept as null', () {
      final result = SearchResultModel.fromJson({
        'query': 'hair',
        'categories': {
          'total': 1,
          'items': [
            {
              'id': 'c',
              'name': 'Haircuts',
              'subtitle': null,
              'image_url': null,
            },
          ],
        },
      });

      final category = result.categories.items.single;
      expect(category.description, isNull);
      expect(category.imageUrl, isNull);
    });

    test('withFavorite flips only the matching shop', () {
      final json = _sample();
      (json['businesses'] as Map<String, dynamic>)['items'] = [
        {'id': 'a', 'is_favorited': false},
        {'id': 'b', 'is_favorited': false},
      ];
      final result = SearchResultModel.fromJson(json).withFavorite('b', true);

      expect(result.businesses.items.map((shop) => shop.isFavorited), [
        false,
        true,
      ]);
      expect(result.businesses.total, 12);
    });
  });

  test('QuickFilterModel parses a chip', () {
    final filter = QuickFilterModel.fromJson({
      'label': 'Haircuts',
      'category_id': 'cat-1',
      'business_count': 23,
    });

    expect(filter.label, 'Haircuts');
    expect(filter.categoryId, 'cat-1');
    expect(filter.businessCount, 23);
  });
}
