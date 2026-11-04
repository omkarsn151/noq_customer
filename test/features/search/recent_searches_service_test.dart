import 'package:flutter_test/flutter_test.dart';
import 'package:noq/core/services/recent_searches_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final service = RecentSearchesService();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('newest first, and a repeat in another case moves to the top', () async {
    await service.add('Hair');
    await service.add('spa');

    expect(await service.add(' hair '), ['hair', 'spa']);
  });

  test('keeps only the newest ${RecentSearchesService.maxEntries}', () async {
    for (var i = 0; i <= RecentSearchesService.maxEntries; i++) {
      await service.add('query $i');
    }

    final all = await service.getAll();
    expect(all, hasLength(RecentSearchesService.maxEntries));
    expect(all.first, 'query ${RecentSearchesService.maxEntries}');
    expect(all, isNot(contains('query 0')));
  });

  test('ignores text too short to search', () async {
    expect(await service.add(' h '), isEmpty);
  });

  test('remove matches regardless of case', () async {
    await service.add('hair');
    await service.add('spa');

    expect(await service.remove('HAIR'), ['spa']);
  });

  test('clear empties the list', () async {
    await service.add('hair');
    await service.clear();

    expect(await service.getAll(), isEmpty);
  });
}
