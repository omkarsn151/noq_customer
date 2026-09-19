import 'package:equatable/equatable.dart';
import 'package:noq/features/cart/data/cart_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final CartModel cart;
  final String? removingItemId;

  const CartLoaded({required this.cart, this.removingItemId});

  @override
  List<Object?> get props => [cart, removingItemId];
}

class CartFailure extends CartState {
  final String message;

  const CartFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Transient state emitted when removing an item fails, so the screen can show
/// an error snackbar. It is immediately followed by [CartLoaded] with the
/// unchanged cart.
class CartItemRemoveFailure extends CartState {
  final String message;

  const CartItemRemoveFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
