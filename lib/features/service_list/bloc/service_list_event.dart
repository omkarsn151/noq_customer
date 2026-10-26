import 'package:equatable/equatable.dart';

abstract class ServiceListEvent extends Equatable {
  const ServiceListEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the shop's sections and clears any cached section services.
class ServiceListRequested extends ServiceListEvent {
  final String businessId;

  const ServiceListRequested({required this.businessId});

  @override
  List<Object?> get props => [businessId];
}

/// A section was opened; fetch its services unless already cached.
class ServiceListSectionOpened extends ServiceListEvent {
  final String subCategoryId;

  const ServiceListSectionOpened({required this.subCategoryId});

  @override
  List<Object?> get props => [subCategoryId];
}
