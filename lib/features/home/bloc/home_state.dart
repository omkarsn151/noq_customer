import 'package:equatable/equatable.dart';
import 'package:noq/features/home/data/home_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final HomeModel home;

  const HomeLoaded({required this.home});

  // HomeModel is a plain model, so each load counts as a new state.
  @override
  List<Object?> get props => [identityHashCode(home)];
}

class HomeFailure extends HomeState {
  final String message;

  const HomeFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
