import 'package:equatable/equatable.dart';

abstract class AddToCartState extends Equatable {
  const AddToCartState();

  @override
  List<Object?> get props => [];
}

class AddToCartInitial extends AddToCartState {
  const AddToCartInitial();
}

class AddToCartLoading extends AddToCartState {
  final String serviceId;

  const AddToCartLoading({required this.serviceId});

  @override
  List<Object?> get props => [serviceId];
}

class AddToCartSuccess extends AddToCartState {
  final String serviceId;
  final String message;

  const AddToCartSuccess({required this.serviceId, required this.message});

  @override
  List<Object?> get props => [serviceId, message];
}

class AddToCartFailure extends AddToCartState {
  final String serviceId;
  final String message;

  const AddToCartFailure({required this.serviceId, required this.message});

  @override
  List<Object?> get props => [serviceId, message];
}

class RemoveFromCartLoading extends AddToCartState {
  final String serviceId;

  const RemoveFromCartLoading({required this.serviceId});

  @override
  List<Object?> get props => [serviceId];
}

class RemoveFromCartSuccess extends AddToCartState {
  final String serviceId;
  final String message;

  const RemoveFromCartSuccess({required this.serviceId, required this.message});

  @override
  List<Object?> get props => [serviceId, message];
}

class RemoveFromCartFailure extends AddToCartState {
  final String serviceId;
  final String message;

  const RemoveFromCartFailure({required this.serviceId, required this.message});

  @override
  List<Object?> get props => [serviceId, message];
}
