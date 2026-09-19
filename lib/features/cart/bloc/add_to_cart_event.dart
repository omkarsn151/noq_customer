import 'package:equatable/equatable.dart';

abstract class AddToCartEvent extends Equatable {
  const AddToCartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCartRequested extends AddToCartEvent {
  final String serviceId;

  const AddToCartRequested({required this.serviceId});

  @override
  List<Object?> get props => [serviceId];
}

class RemoveFromCartRequested extends AddToCartEvent {
  final String serviceId;
  final String cartItemId;

  const RemoveFromCartRequested({
    required this.serviceId,
    required this.cartItemId,
  });

  @override
  List<Object?> get props => [serviceId, cartItemId];
}
