import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/cart/bloc/cart_event.dart';
import 'package:noq/features/cart/bloc/cart_state.dart';
import 'package:noq/features/cart/repository/cart_repository.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repository;

  CartBloc(this._repository) : super(const CartInitial()) {
    on<CartItemsRequested>(_onCartItemsRequested);
    on<CartItemRemoveRequested>(_onCartItemRemoveRequested);
  }

  Future<void> _onCartItemsRequested(
    CartItemsRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());
    try {
      final cart = await _repository.getCart();
      emit(CartLoaded(cart: cart));
    } on ApiException catch (e) {
      emit(CartFailure(message: e.message));
    } catch (e) {
      emit(CartFailure(message: e.toString()));
    }
  }

  Future<void> _onCartItemRemoveRequested(
    CartItemRemoveRequested event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    emit(CartLoaded(cart: currentState.cart, removingItemId: event.itemId));
    try {
      await _repository.removeCartItem(event.itemId);
      final cart = await _repository.getCart();
      emit(CartLoaded(cart: cart));
    } on ApiException catch (e) {
      emit(CartItemRemoveFailure(message: e.message));
      emit(CartLoaded(cart: currentState.cart));
    } catch (e) {
      emit(CartItemRemoveFailure(message: e.toString()));
      emit(CartLoaded(cart: currentState.cart));
    }
  }
}
