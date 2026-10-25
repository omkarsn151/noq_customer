import 'package:equatable/equatable.dart';

abstract class BusinessListEvent extends Equatable {
  const BusinessListEvent();

  @override
  List<Object?> get props => [];
}

/// Load the first page of shops in [categoryId], replacing whatever list was
/// shown before.
class BusinessListRequested extends BusinessListEvent {
  final String categoryId;

  const BusinessListRequested({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

/// Append the next page once the list is scrolled near its end.
class BusinessListNextPageRequested extends BusinessListEvent {
  const BusinessListNextPageRequested();
}
