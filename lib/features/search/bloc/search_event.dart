import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// The screen opened: load quick filters and recent searches.
class SearchStarted extends SearchEvent {
  const SearchStarted();
}

/// Input to the search box. These share one handler, so each new input
/// cancels whatever the previous one was still doing (a pending debounce or
/// an in-flight request).
sealed class SearchInputEvent extends SearchEvent {
  const SearchInputEvent();
}

/// The text changed. Searched after a short pause in typing.
class SearchQueryChanged extends SearchInputEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// The keyboard search action, a recent search tapped, or a result tapped.
/// Saved to recent searches and searched right away.
class SearchSubmitted extends SearchInputEvent {
  final String query;

  const SearchSubmitted(this.query);

  @override
  List<Object?> get props => [query];
}

/// The clear button was pressed.
class SearchCleared extends SearchInputEvent {
  const SearchCleared();
}

class RecentSearchRemoved extends SearchEvent {
  final String query;

  const RecentSearchRemoved(this.query);

  @override
  List<Object?> get props => [query];
}

class RecentSearchesCleared extends SearchEvent {
  const RecentSearchesCleared();
}

/// A shop's heart was saved/cleared; patch its card without searching again.
class SearchFavoriteChanged extends SearchEvent {
  final String businessId;
  final bool isFavorited;

  const SearchFavoriteChanged({
    required this.businessId,
    required this.isFavorited,
  });

  @override
  List<Object?> get props => [businessId, isFavorited];
}
