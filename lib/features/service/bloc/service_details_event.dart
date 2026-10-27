import 'package:equatable/equatable.dart';

abstract class ServiceDetailsEvent extends Equatable {
  const ServiceDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// Loads (or reloads) one service of a shop.
class ServiceDetailsRequested extends ServiceDetailsEvent {
  final String businessId;
  final String serviceId;

  const ServiceDetailsRequested({
    required this.businessId,
    required this.serviceId,
  });

  @override
  List<Object?> get props => [businessId, serviceId];
}
