import 'package:shared_preferences/shared_preferences.dart';

/// The customer's recent search queries, newest first.
///
/// Kept on the device only: there is no server endpoint for this. Stored in
/// shared preferences rather than secure storage because it isn't sensitive,
/// and so logging out (which clears secure storage) leaves it intact.
class RecentSearchesService {
  RecentSearchesService._internal();

  static final RecentSearchesService _instance =
      RecentSearchesService._internal();
  factory RecentSearchesService() => _instance;

  static const _key = 'recent_searches';
  static const maxEntries = 10;

  /// Same minimum the search API accepts; shorter text is never a search.
  static const minQueryLength = 2;

  Future<List<String>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? const [];
  }

  /// Moves [query] to the top, replacing any entry that differs only in case,
  /// and drops the oldest beyond [maxEntries]. Returns the updated list.
  Future<List<String>> add(String query) async {
    final trimmed = query.trim();
    final current = await getAll();
    if (trimmed.length < minQueryLength) return current;

    final updated = [
      trimmed,
      ...current.where((e) => !_sameQuery(e, trimmed)),
    ].take(maxEntries).toList();

    return _save(updated);
  }

  /// Returns the updated list.
  Future<List<String>> remove(String query) async {
    final current = await getAll();
    return _save(current.where((e) => !_sameQuery(e, query.trim())).toList());
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<List<String>> _save(List<String> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, entries);
    return entries;
  }

  static bool _sameQuery(String a, String b) =>
      a.toLowerCase() == b.toLowerCase();
}
