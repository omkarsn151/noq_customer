import 'package:equatable/equatable.dart';

abstract class BusinessDetailsEvent extends Equatable {
  const BusinessDetailsEvent();

  @override
  List<Object?> get props => [];
}

class BusinessDetailsRequested extends BusinessDetailsEvent {
  final String businessId;

  const BusinessDetailsRequested(this.businessId);

  @override
  List<Object?> get props => [businessId];
}
