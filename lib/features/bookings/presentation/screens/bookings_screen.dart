import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/common/app_pill_tab_bar.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/bookings/bloc/bookings_bloc.dart';
import 'package:noq/features/bookings/bloc/bookings_event.dart';
import 'package:noq/features/bookings/bloc/bookings_state.dart';
import 'package:noq/features/bookings/data/booking_tab.dart';
import 'package:noq/features/bookings/presentation/widgets/bookings_tile.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: BookingTab.values.length,
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    _tabController.addListener(_onTabChanged);
    context.read<BookingsBloc>().add(
      BookingsRequested(tab: BookingTab.values.first, refresh: true),
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  /// Loads a tab the first time it is opened.
  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    context.read<BookingsBloc>().add(
      BookingsRequested(tab: BookingTab.values[_tabController.index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'Bookings', showLeading: false),
      body: BlocBuilder<BookingsBloc, BookingsState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppPillTabBar(
                controller: _tabController,
                labels: [for (final tab in BookingTab.values) tab.label],
              ),
              SizedBox(height: 2.5.h),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    for (final tab in BookingTab.values)
                      _BookingsList(tab: tab, tabState: state.tabFor(tab)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  /// How close to the bottom of the list the next page starts loading.
  static const double _loadMoreThreshold = 300;

  final BookingTab tab;
  final BookingsTabState tabState;

  const _BookingsList({required this.tab, required this.tabState});

  void _loadFirstPage(BuildContext context) {
    context.read<BookingsBloc>().add(
      BookingsRequested(tab: tab, refresh: true),
    );
  }

  /// Requests the next page once the list is scrolled near its end.
  bool _onScroll(BuildContext context, ScrollNotification notification) {
    final position = notification.metrics;
    if (position.axis != Axis.vertical) return false;

    if (tabState.hasMore &&
        !tabState.isLoadingMore &&
        position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      context.read<BookingsBloc>().add(BookingsNextPageRequested(tab: tab));
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (tabState.status == BookingsTabStatus.initial) {
      // A refresh drops every cached tab, so a tab can come back into view
      // with nothing in it and nothing fetching. It asks for itself here; the
      // bloc ignores the ask if a load is already running.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        context.read<BookingsBloc>().add(BookingsRequested(tab: tab));
      });
      return const Center(child: CircularProgressIndicator());
    }

    if (tabState.status == BookingsTabStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (tabState.status == BookingsTabStatus.failure) {
      return _BookingsMessage(
        message: tabState.message,
        onRetry: () => _loadFirstPage(context),
      );
    }

    if (tabState.bookings.isEmpty) {
      return _BookingsMessage(
        message: 'No ${tab.label.toLowerCase()} bookings',
        onRetry: () => _loadFirstPage(context),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => _loadFirstPage(context),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) => _onScroll(context, notification),
        child: ListView.separated(
          padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 2.h),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: tabState.bookings.length + (tabState.isLoadingMore ? 1 : 0),
          separatorBuilder: (_, _) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            if (index == tabState.bookings.length) {
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
            return BookingsTile(booking: tabState.bookings[index]);
          },
        ),
      ),
    );
  }
}

class _BookingsMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _BookingsMessage({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    // Kept scrollable so pull-to-refresh still works on an empty or failed tab.
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => onRetry(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: 1.5.h),
          Center(
            child: TextButton(onPressed: onRetry, child: const Text('Retry')),
          ),
        ],
      ),
    );
  }
}
