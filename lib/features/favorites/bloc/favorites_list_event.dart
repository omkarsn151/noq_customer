import 'package:equatable/equatable.dart';

abstract class FavoritesListEvent extends Equatable {
  const FavoritesListEvent();

  @override
  List<Object?> get props => [];
}

/// Load the first page, replacing whatever list was shown before.
class FavoritesListRequested extends FavoritesListEvent {
  const FavoritesListRequested();
}

/// Append the next page once the list is scrolled near its end.
class FavoritesListNextPageRequested extends FavoritesListEvent {
  const FavoritesListNextPageRequested();
}

/// A shop's heart was saved/cleared somewhere in the app.
class FavoritesListItemChanged extends FavoritesListEvent {
  final String businessId;
  final bool isFavorited;

  const FavoritesListItemChanged({
    required this.businessId,
    required this.isFavorited,
  });

  @override
  List<Object?> get props => [businessId, isFavorited];
}
