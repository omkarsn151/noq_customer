import 'package:equatable/equatable.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object?> get props => [];
}

/// Load the first page. Ignored while loading or once loaded, unless
/// [refresh] is set.
class CategoriesRequested extends CategoriesEvent {
  final bool refresh;

  const CategoriesRequested({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

/// Append the next page once the list is scrolled near its end.
class CategoriesNextPageRequested extends CategoriesEvent {
  const CategoriesNextPageRequested();
}
