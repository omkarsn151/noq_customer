import 'package:equatable/equatable.dart';

abstract class BusinessListEvent extends Equatable {
  const BusinessListEvent();

  @override
  List<Object?> get props => [];
}

/// Load the first page of shops in [categoryId], replacing whatever list was
/// shown before.
class BusinessListRequested extends BusinessListEvent {
  final String categoryId;

  const BusinessListRequested({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

/// Append the next page once the list is scrolled near its end.
class BusinessListNextPageRequested extends BusinessListEvent {
  const BusinessListNextPageRequested();
}

/// A shop's heart was saved/cleared; patch its card without a reload.
class BusinessListFavoriteChanged extends BusinessListEvent {
  final String businessId;
  final bool isFavorited;

  const BusinessListFavoriteChanged({
    required this.businessId,
    required this.isFavorited,
  });

  @override
  List<Object?> get props => [businessId, isFavorited];
}
