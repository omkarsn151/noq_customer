import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/common/app_search_field.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/service_list/bloc/service_list_bloc.dart';
import 'package:noq/features/service_list/bloc/service_list_event.dart';
import 'package:noq/features/service_list/bloc/service_list_state.dart';
import 'package:noq/features/service_list/presentation/widgets/service_category_section.dart';

class ServiceListScreen extends StatefulWidget {
  final String businessId;

  const ServiceListScreen({super.key, required this.businessId});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  // Search is wired to the in-shop search API in a later change.
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _load() {
    context.read<ServiceListBloc>().add(
      ServiceListRequested(businessId: widget.businessId),
    );
  }

  bool _isCurrent(ServiceListState state) =>
      state.businessId == widget.businessId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'All Services'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 1.5.h),
            child: AppSearchField(
              controller: _controller,
              hintText: 'Search services...',
              onChanged: (_) {},
              onClear: _controller.clear,
            ),
          ),
          Expanded(
            child: BlocConsumer<ServiceListBloc, ServiceListState>(
              listenWhen: (previous, current) =>
                  _isCurrent(current) && current.status != previous.status,
              listener: (context, state) {
                if (state.status == ServiceListStatus.notFound) {
                  // The shop is no longer public — leave instead of retrying.
                  AppSnackbar.show(
                    context,
                    message: 'This business is no longer available.',
                    type: AppSnackBarType.error,
                  );
                  context.pop();
                }
              },
              builder: (context, state) => _buildBody(state),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ServiceListState state) {
    // The bloc is app-wide, so ignore another shop's sections.
    if (!_isCurrent(state)) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (state.status) {
      case ServiceListStatus.initial:
      case ServiceListStatus.loading:
      case ServiceListStatus.notFound:
        return const Center(child: CircularProgressIndicator());
      case ServiceListStatus.failure:
        return _ServiceListMessage(message: state.message, onRetry: _load);
      case ServiceListStatus.success:
        if (state.sections.isEmpty) {
          return _ServiceListMessage(
            message: 'No services available',
            onRetry: _load,
            showRetry: false,
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => _load(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              for (final section in state.sections)
                ServiceCategorySection(
                  key: ValueKey(section.id),
                  businessId: widget.businessId,
                  section: section,
                  services: state.sectionServices[section.id],
                  onExpand: () => context.read<ServiceListBloc>().add(
                    ServiceListSectionOpened(subCategoryId: section.id),
                  ),
                ),
            ],
          ),
        );
    }
  }
}

class _ServiceListMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool showRetry;

  const _ServiceListMessage({
    required this.message,
    required this.onRetry,
    this.showRetry = true,
  });

  @override
  Widget build(BuildContext context) {
    // Kept scrollable so pull-to-refresh still works on an empty or failed list.
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => onRetry(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 15.h),
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
          if (showRetry) ...[
            SizedBox(height: 1.5.h),
            Center(
              child: TextButton(onPressed: onRetry, child: const Text('Retry')),
            ),
          ],
        ],
      ),
    );
  }
}
