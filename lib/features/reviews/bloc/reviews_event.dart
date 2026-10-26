import 'package:equatable/equatable.dart';

abstract class ReviewsEvent extends Equatable {
  const ReviewsEvent();

  @override
  List<Object?> get props => [];
}

/// Load the first page of [businessId]'s reviews, replacing whatever list was
/// shown before.
class ReviewsRequested extends ReviewsEvent {
  final String businessId;

  const ReviewsRequested({required this.businessId});

  @override
  List<Object?> get props => [businessId];
}

/// Append the next page once the list is scrolled near its end.
class ReviewsNextPageRequested extends ReviewsEvent {
  const ReviewsNextPageRequested();
}
