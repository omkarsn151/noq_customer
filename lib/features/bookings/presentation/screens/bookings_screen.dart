import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/bookings/bloc/bookings_bloc.dart';
import 'package:noq/features/bookings/bloc/bookings_event.dart';
import 'package:noq/features/bookings/bloc/bookings_state.dart';
import 'package:noq/features/bookings/data/booking_tab.dart';
import 'package:noq/features/bookings/presentation/widgets/booking_tab_pills.dart';
import 'package:noq/features/bookings/presentation/widgets/bookings_tile.dart';
import 'package:noq/features/bookings/repository/bookings_repository.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingsBloc>(
      create: (_) => BookingsBloc(BookingsRepository())
        ..add(const BookingsRequested(tab: BookingTab.upcoming)),
      child: const _BookingsView(),
    );
  }
}

class _BookingsView extends StatefulWidget {
  const _BookingsView();

  @override
  State<_BookingsView> createState() => _BookingsViewState();
}

class _BookingsViewState extends State<_BookingsView> {
  /// How close to the bottom of the list the next page starts loading.
  static const double _loadMoreThreshold = 300;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - _loadMoreThreshold) return;
    // The bloc drops the event when a fetch is already running or the last
    // page has been reached, so repeat fires are harmless.
    context.read<BookingsBloc>().add(const BookingsNextPageRequested());
  }

  BookingTab _selectedTab(BookingsState state) => switch (state) {
    BookingsLoaded() => state.tab,
    BookingsFailure() => state.tab,
    _ => BookingTab.upcoming,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'Bookings', showLeading: false),
      body: BlocConsumer<BookingsBloc, BookingsState>(
        listenWhen: (previous, current) =>
            current is BookingsLoaded &&
            current.pageError != null &&
            (previous is! BookingsLoaded ||
                previous.pageError != current.pageError),
        listener: (context, state) {
          AppSnackbar.error(context, (state as BookingsLoaded).pageError!);
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookingTabPills(
                  selected: _selectedTab(state),
                  onSelected: (tab) => context.read<BookingsBloc>().add(
                    BookingsTabChanged(tab),
                  ),
                ),
                SizedBox(height: 2.5.h),
                Expanded(child: _buildList(context, state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, BookingsState state) {
    return switch (state) {
      BookingsFailure() => _CenteredMessage(message: state.message),
      BookingsLoaded() => state.isTabLoading
          ? const Center(child: CircularProgressIndicator())
          : _BookingsList(state: state, controller: _scrollController),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _BookingsList extends StatelessWidget {
  final BookingsLoaded state;
  final ScrollController controller;

  const _BookingsList({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        context.read<BookingsBloc>().add(const BookingsRefreshed());
      },
      child: state.bookings.isEmpty
          // Kept scrollable so pull-to-refresh still works on an empty tab.
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 20.h),
                _CenteredMessage(
                  message: 'No ${state.tab.label.toLowerCase()} bookings',
                ),
              ],
            )
          : ListView.separated(
              controller: controller,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 2.h),
              itemCount: state.bookings.length + (state.isPageLoading ? 1 : 0),
              separatorBuilder: (_, _) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                if (index >= state.bookings.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                return BookingsTile(booking: state.bookings[index]);
              },
            ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  final String message;

  const _CenteredMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
