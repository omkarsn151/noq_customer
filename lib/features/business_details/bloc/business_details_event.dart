import 'package:equatable/equatable.dart';

abstract class BusinessDetailsEvent extends Equatable {
  const BusinessDetailsEvent();

  @override
  List<Object?> get props => [];
}

class BusinessDetailsRequested extends BusinessDetailsEvent {
  final String businessId;

  /// Reload in the background (e.g. after a cart change): keep the loaded
  /// page on screen and keep it on failure instead of showing an error.
  final bool silent;

  const BusinessDetailsRequested(this.businessId, {this.silent = false});

  @override
  List<Object?> get props => [businessId, silent];
}

/// The heart was saved/cleared; patch the loaded page without a reload.
class BusinessDetailsFavoriteChanged extends BusinessDetailsEvent {
  final String businessId;
  final bool isFavorited;

  const BusinessDetailsFavoriteChanged({
    required this.businessId,
    required this.isFavorited,
  });

  @override
  List<Object?> get props => [businessId, isFavorited];
}
