import 'package:equatable/equatable.dart';
import 'package:noq/features/business/data/business_model.dart';

abstract class BusinessState extends Equatable {
  const BusinessState();

  @override
  List<Object?> get props => [];
}

class BusinessInitial extends BusinessState {
  const BusinessInitial();
}

class BusinessLoading extends BusinessState {
  const BusinessLoading();
}

class BusinessLoaded extends BusinessState {
  final List<BusinessModel> businesses;

  const BusinessLoaded({required this.businesses});

  @override
  List<Object?> get props => [businesses];
}

class BusinessFailure extends BusinessState {
  final String message;

  const BusinessFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
