import 'package:equatable/equatable.dart';
import 'package:noq/core/models/paginated_response.dart';
import 'package:noq/features/bookings/data/booking_model.dart';
import 'package:noq/features/bookings/data/booking_tab.dart';

/// Sentinel used by [BookingsLoaded.copyWith] so that nullable fields can be
/// cleared as well as replaced.
const Object _unset = Object();

abstract class BookingsState extends Equatable {
  const BookingsState();

  @override
  List<Object?> get props => [];
}

class BookingsInitial extends BookingsState {
  const BookingsInitial();
}

class BookingsLoading extends BookingsState {
  const BookingsLoading();
}

class BookingsLoaded extends BookingsState {
  final BookingTab tab;
  final List<BookingModel> bookings;
  final PageMeta meta;

  /// True while a tab switch is being fetched; the list area shows a spinner
  /// but the pills stay put.
  final bool isTabLoading;

  /// True while the next page is being fetched; only the list footer shows a
  /// spinner.
  final bool isPageLoading;

  /// Error from a failed tab switch or next-page fetch, surfaced as a snackbar
  /// so the already-loaded list survives; a first-load failure emits
  /// [BookingsFailure] instead.
  final String? pageError;

  const BookingsLoaded({
    required this.tab,
    required this.bookings,
    required this.meta,
    this.isTabLoading = false,
    this.isPageLoading = false,
    this.pageError,
  });

  bool get hasReachedEnd => !meta.hasNextPage;

  BookingsLoaded copyWith({
    BookingTab? tab,
    List<BookingModel>? bookings,
    PageMeta? meta,
    bool? isTabLoading,
    bool? isPageLoading,
    Object? pageError = _unset,
  }) {
    return BookingsLoaded(
      tab: tab ?? this.tab,
      bookings: bookings ?? this.bookings,
      meta: meta ?? this.meta,
      isTabLoading: isTabLoading ?? this.isTabLoading,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      pageError: identical(pageError, _unset)
          ? this.pageError
          : pageError as String?,
    );
  }

  @override
  List<Object?> get props => [
    tab,
    bookings,
    // PageMeta is a plain model, so compare the fields the UI depends on.
    meta.page,
    meta.totalPages,
    meta.totalItems,
    isTabLoading,
    isPageLoading,
    pageError,
  ];
}

class BookingsFailure extends BookingsState {
  final String message;

  /// Kept so the pills stay usable on a failed screen and a retry knows which
  /// tab to reload.
  final BookingTab tab;

  const BookingsFailure({required this.message, required this.tab});

  @override
  List<Object?> get props => [message, tab];
}
