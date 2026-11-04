import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/search/bloc/search_services_bloc.dart';
import 'package:noq/features/search/bloc/search_services_event.dart';
import 'package:noq/features/search/bloc/search_services_state.dart';
import 'package:noq/features/search/presentation/widgets/search_service_tile.dart';

/// "See all services": every service matching [query], page by page.
class SearchServicesScreen extends StatefulWidget {
  final String query;

  const SearchServicesScreen({super.key, required this.query});

  @override
  State<SearchServicesScreen> createState() => _SearchServicesScreenState();
}

class _SearchServicesScreenState extends State<SearchServicesScreen> {
  /// Distance from the bottom, in pixels, at which the next page is fetched.
  static const double _loadMoreThreshold = 300;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<SearchServicesBloc>().add(
      SearchServicesRequested(widget.query),
    );
  }

  /// Requests the next page once the list is scrolled near its end.
  bool _onScroll(SearchServicesState state, ScrollNotification notification) {
    final position = notification.metrics;
    if (position.axis != Axis.vertical) return false;

    if (state.hasMore &&
        !state.isLoadingMore &&
        position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      context.read<SearchServicesBloc>().add(
        const SearchServicesNextPageRequested(),
      );
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'Services for "${widget.query}"'),
      body: BlocConsumer<SearchServicesBloc, SearchServicesState>(
        // A failed next page keeps the list; say so without replacing it.
        listenWhen: (previous, current) =>
            previous.isLoadingMore &&
            !current.isLoadingMore &&
            current.message.isNotEmpty,
        listener: (context, state) => AppSnackbar.error(context, state.message),
        builder: (context, state) {
          switch (state.status) {
            case SearchServicesStatus.initial:
            case SearchServicesStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case SearchServicesStatus.failure:
              return _SearchServicesMessage(
                message: state.message,
                onRetry: _load,
              );
            case SearchServicesStatus.success:
              if (state.services.isEmpty) {
                return _SearchServicesMessage(
                  message: 'No services match "${widget.query}"',
                  onRetry: _load,
                );
              }
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async => _load(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) =>
                      _onScroll(state, notification),
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 3.h),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount:
                        state.services.length + (state.isLoadingMore ? 1 : 0),
                    separatorBuilder: (_, _) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      child: const Divider(
                        height: 1,
                        color: AppColors.borderLight,
                      ),
                    ),
                    itemBuilder: (context, index) {
                      if (index == state.services.length) {
                        return const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      return SearchServiceTile(service: state.services[index]);
                    },
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}

class _SearchServicesMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _SearchServicesMessage({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    // Kept scrollable so pull-to-refresh still works on an empty or failed list.
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
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
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
