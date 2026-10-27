import 'package:equatable/equatable.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}

class FavoriteLoading extends FavoriteState {
  final String businessId;

  const FavoriteLoading({required this.businessId});

  @override
  List<Object?> get props => [businessId];
}

class FavoriteSuccess extends FavoriteState {
  final String businessId;

  /// The heart's new state.
  final bool isFavorited;
  final String message;

  const FavoriteSuccess({
    required this.businessId,
    required this.isFavorited,
    required this.message,
  });

  @override
  List<Object?> get props => [businessId, isFavorited, message];
}

class FavoriteFailure extends FavoriteState {
  final String businessId;
  final String message;

  const FavoriteFailure({required this.businessId, required this.message});

  @override
  List<Object?> get props => [businessId, message];
}
