import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/cart/bloc/add_to_cart_event.dart';
import 'package:noq/features/cart/bloc/add_to_cart_state.dart';
import 'package:noq/features/cart/repository/cart_repository.dart';

class AddToCartBloc extends Bloc<AddToCartEvent, AddToCartState> {
  final CartRepository _repository;

  AddToCartBloc(this._repository) : super(const AddToCartInitial()) {
    on<AddToCartRequested>(_onAddToCartRequested);
    on<RemoveFromCartRequested>(_onRemoveFromCartRequested);
  }

  Future<void> _onAddToCartRequested(
    AddToCartRequested event,
    Emitter<AddToCartState> emit,
  ) async {
    emit(AddToCartLoading(serviceId: event.serviceId));
    try {
      final message = await _repository.addToCart(event.serviceId);
      emit(AddToCartSuccess(serviceId: event.serviceId, message: message));
    } on ApiException catch (e) {
      emit(AddToCartFailure(serviceId: event.serviceId, message: e.message));
    } catch (e) {
      emit(AddToCartFailure(serviceId: event.serviceId, message: e.toString()));
    }
  }

  Future<void> _onRemoveFromCartRequested(
    RemoveFromCartRequested event,
    Emitter<AddToCartState> emit,
  ) async {
    emit(RemoveFromCartLoading(serviceId: event.serviceId));
    try {
      final message = await _repository.removeCartItem(event.cartItemId);
      emit(RemoveFromCartSuccess(serviceId: event.serviceId, message: message));
    } on ApiException catch (e) {
      emit(RemoveFromCartFailure(serviceId: event.serviceId, message: e.message));
    } catch (e) {
      emit(
        RemoveFromCartFailure(serviceId: event.serviceId, message: e.toString()),
      );
    }
  }
}
