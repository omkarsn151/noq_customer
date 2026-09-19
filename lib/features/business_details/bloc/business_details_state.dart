import 'package:equatable/equatable.dart';
import 'package:noq/features/business_details/data/business_details_model.dart';

abstract class BusinessDetailsState extends Equatable {
  const BusinessDetailsState();

  @override
  List<Object?> get props => [];
}

class BusinessDetailsInitial extends BusinessDetailsState {
  const BusinessDetailsInitial();
}

class BusinessDetailsLoading extends BusinessDetailsState {
  const BusinessDetailsLoading();
}

class BusinessDetailsLoaded extends BusinessDetailsState {
  final BusinessDetailsModel details;

  const BusinessDetailsLoaded({required this.details});

  @override
  List<Object?> get props => [details];
}

class BusinessDetailsFailure extends BusinessDetailsState {
  final String message;

  const BusinessDetailsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
