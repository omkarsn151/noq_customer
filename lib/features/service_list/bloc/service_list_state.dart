import 'package:equatable/equatable.dart';
import 'package:noq/features/business_details/data/business_details_model.dart';
import 'package:noq/features/service_list/data/service_list_model.dart';

/// [notFound]: the shop is not public — leave the screen, do not retry.
enum ServiceListStatus { initial, loading, success, failure, notFound }

enum SectionServicesStatus { loading, success, failure }

/// The services of one opened section.
class SectionServices extends Equatable {
  final SectionServicesStatus status;
  final List<BusinessServiceModel> items;
  final String message;

  const SectionServices({
    required this.status,
    this.items = const [],
    this.message = '',
  });

  @override
  List<Object?> get props => [status, items, message];
}

class ServiceListState extends Equatable {
  final ServiceListStatus status;
  final List<ShopSectionModel> sections;

  /// Services of opened sections, keyed by sub-category id. Kept for the
  /// life of the screen so collapsing and re-expanding does not re-fetch.
  final Map<String, SectionServices> sectionServices;

  final String message;
  final String businessId;

  const ServiceListState({
    this.status = ServiceListStatus.initial,
    this.sections = const [],
    this.sectionServices = const {},
    this.message = '',
    this.businessId = '',
  });

  ServiceListState copyWith({
    ServiceListStatus? status,
    List<ShopSectionModel>? sections,
    Map<String, SectionServices>? sectionServices,
    String? message,
  }) {
    return ServiceListState(
      status: status ?? this.status,
      sections: sections ?? this.sections,
      sectionServices: sectionServices ?? this.sectionServices,
      message: message ?? this.message,
      businessId: businessId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    sections,
    sectionServices,
    message,
    businessId,
  ];
}
