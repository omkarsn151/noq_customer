import 'package:equatable/equatable.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object?> get props => [];
}

/// Load the first page.
class CategoriesRequested extends CategoriesEvent {
  const CategoriesRequested();
}

/// Append the next page once the list is scrolled near its end.
class CategoriesNextPageRequested extends CategoriesEvent {
  const CategoriesNextPageRequested();
}
