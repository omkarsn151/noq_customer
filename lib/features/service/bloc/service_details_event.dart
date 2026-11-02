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

  /// Refresh without a spinner, for cart changes on the open service.
  final bool silent;

  const ServiceDetailsRequested({
    required this.businessId,
    required this.serviceId,
    this.silent = false,
  });

  @override
  List<Object?> get props => [businessId, serviceId, silent];
}
