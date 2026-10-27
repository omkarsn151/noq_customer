import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

/// The heart was tapped. [isFavorited] is the heart's current state:
/// a filled heart is cleared, an empty one is saved.
class FavoriteToggled extends FavoriteEvent {
  final String businessId;
  final bool isFavorited;

  const FavoriteToggled({required this.businessId, required this.isFavorited});

  @override
  List<Object?> get props => [businessId, isFavorited];
}
