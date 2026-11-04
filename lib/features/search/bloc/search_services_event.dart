import 'package:equatable/equatable.dart';

abstract class SearchServicesEvent extends Equatable {
  const SearchServicesEvent();

  @override
  List<Object?> get props => [];
}

/// Load the first page of services matching [query], replacing the list.
class SearchServicesRequested extends SearchServicesEvent {
  final String query;

  const SearchServicesRequested(this.query);

  @override
  List<Object?> get props => [query];
}

/// Append the next page once the list is scrolled near its end.
class SearchServicesNextPageRequested extends SearchServicesEvent {
  const SearchServicesNextPageRequested();
}
