import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartItemsRequested extends CartEvent {
  const CartItemsRequested();
}

class CartItemRemoveRequested extends CartEvent {
  final String itemId;

  const CartItemRemoveRequested({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}
