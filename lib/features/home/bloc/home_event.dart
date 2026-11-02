import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Load the Home tab.
class HomeRequested extends HomeEvent {
  const HomeRequested();
}

/// A shop's heart was saved/cleared; patch its nearby card without a reload.
class HomeFavoriteChanged extends HomeEvent {
  final String businessId;
  final bool isFavorited;

  const HomeFavoriteChanged({
    required this.businessId,
    required this.isFavorited,
  });

  @override
  List<Object?> get props => [businessId, isFavorited];
}
