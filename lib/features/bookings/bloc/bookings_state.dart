import 'package:equatable/equatable.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/features/bookings/data/booking_model.dart';
import 'package:noq/features/bookings/data/booking_tab.dart';

enum BookingsTabStatus { initial, loading, success, failure }

/// Loading state of a single tab - each tab paginates independently.
class BookingsTabState extends Equatable {
  final BookingsTabStatus status;
  final List<BookingModel> bookings;
  final PageMeta meta;

  /// True while the next page is being appended.
  final bool isLoadingMore;
  final String message;

  const BookingsTabState({
    this.status = BookingsTabStatus.initial,
    this.bookings = const [],
    this.meta = const PageMeta.empty(),
    this.isLoadingMore = false,
    this.message = '',
  });

  bool get hasMore => meta.hasNextPage;

  BookingsTabState copyWith({
    BookingsTabStatus? status,
    List<BookingModel>? bookings,
    PageMeta? meta,
    bool? isLoadingMore,
    String? message,
  }) {
    return BookingsTabState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      meta: meta ?? this.meta,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    bookings,
    // PageMeta is a plain model, so compare the fields the UI depends on.
    meta.page,
    meta.totalPages,
    meta.totalItems,
    isLoadingMore,
    message,
  ];
}

class BookingsState extends Equatable {
  final Map<BookingTab, BookingsTabState> tabs;

  const BookingsState({this.tabs = const {}});

  BookingsTabState tabFor(BookingTab tab) =>
      tabs[tab] ?? const BookingsTabState();

  BookingsState copyWithTab(BookingTab tab, BookingsTabState tabState) {
    return BookingsState(tabs: {...tabs, tab: tabState});
  }

  @override
  List<Object?> get props => [tabs];
}
