import 'package:equatable/equatable.dart';
import 'package:noq/features/service/data/service_details_model.dart';

/// [notFound]: the service or its shop is not public — leave the screen,
/// do not retry.
enum ServiceDetailsStatus { initial, loading, success, failure, notFound }

class ServiceDetailsState extends Equatable {
  final ServiceDetailsStatus status;

  /// Null until the first successful load.
  final ServiceDetailsModel? service;

  final String message;
  final String serviceId;

  const ServiceDetailsState({
    this.status = ServiceDetailsStatus.initial,
    this.service,
    this.message = '',
    this.serviceId = '',
  });

  ServiceDetailsState copyWith({
    ServiceDetailsStatus? status,
    ServiceDetailsModel? service,
    String? message,
  }) {
    return ServiceDetailsState(
      status: status ?? this.status,
      service: service ?? this.service,
      message: message ?? this.message,
      serviceId: serviceId,
    );
  }

  @override
  List<Object?> get props => [status, service, message, serviceId];
}
