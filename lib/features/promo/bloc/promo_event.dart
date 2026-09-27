import 'package:equatable/equatable.dart';

abstract class PromoEvent extends Equatable {
  const PromoEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch the offers for the current cart. Dispatched each time the offers
/// sheet opens, because the list is priced against the live basket.
class PromoListRequested extends PromoEvent {
  const PromoListRequested();
}

/// Put [promoId] on the cart, replacing any previous selection.
class PromoApplyRequested extends PromoEvent {
  final String promoId;

  const PromoApplyRequested({required this.promoId});

  @override
  List<Object?> get props => [promoId];
}

/// Clear whichever code is on the cart.
class PromoRemoveRequested extends PromoEvent {
  const PromoRemoveRequested();
}
