import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/cart/bloc/add_to_cart_bloc.dart';
import 'package:noq/features/cart/bloc/add_to_cart_state.dart';
import 'package:noq/features/service/bloc/service_details_bloc.dart';
import 'package:noq/features/service/bloc/service_details_event.dart';
import 'package:noq/features/service/bloc/service_details_state.dart';
import 'package:noq/features/service/presentation/widgets/service_bottom_bar.dart';
import 'package:noq/features/service/presentation/widgets/service_gallery_section.dart';
import 'package:noq/features/service/presentation/widgets/service_hero_section.dart';
import 'package:noq/features/service/presentation/widgets/service_info_section.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String businessId;
  final String serviceId;

  const ServiceDetailsScreen({
    super.key,
    required this.businessId,
    required this.serviceId,
  });

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<ServiceDetailsBloc>().add(
      ServiceDetailsRequested(
        businessId: widget.businessId,
        serviceId: widget.serviceId,
      ),
    );
  }

  bool _isCurrent(ServiceDetailsState state) =>
      state.serviceId == widget.serviceId;

  /// Cart add/remove results for this service only.
  void _onCartChanged(BuildContext context, AddToCartState state) {
    switch (state) {
      case AddToCartSuccess(:final serviceId, :final message) ||
              RemoveFromCartSuccess(:final serviceId, :final message)
          when serviceId == widget.serviceId:
        AppSnackbar.success(context, message);
        // Re-fetch so is_in_cart / cart_item_id are current for the button.
        _load();
      case AddToCartFailure(:final serviceId, :final message) ||
              RemoveFromCartFailure(:final serviceId, :final message)
          when serviceId == widget.serviceId:
        AppSnackbar.error(context, message);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddToCartBloc, AddToCartState>(
      listener: _onCartChanged,
      child: BlocConsumer<ServiceDetailsBloc, ServiceDetailsState>(
        listenWhen: (previous, current) =>
            _isCurrent(current) && current.status != previous.status,
        listener: (context, state) {
          if (state.status == ServiceDetailsStatus.notFound) {
            // The service or shop is no longer public — leave, do not retry.
            AppSnackbar.show(
              context,
              message: 'This service is no longer available.',
              type: AppSnackBarType.error,
            );
            context.pop();
          }
        },
        builder: (context, state) => _buildScaffold(state),
      ),
    );
  }

  Widget _buildScaffold(ServiceDetailsState state) {
    // The bloc is app-wide, so ignore another service's data.
    final service = _isCurrent(state) ? state.service : null;

    if (service != null && state.status == ServiceDetailsStatus.success) {
      return Scaffold(
        body: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => _load(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                ServiceHeroSection(heroUrl: service.heroUrl),
                SizedBox(height: 2.h),
                ServiceInfoSection(service: service),
                SizedBox(height: 3.h),
                ServiceGallerySection(images: service.gallery),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ServiceBottomBar(service: service),
      );
    }

    return Scaffold(
      appBar: const AppAppBar(title: 'Service Details'),
      body: _isCurrent(state) && state.status == ServiceDetailsStatus.failure
          ? _ServiceDetailsMessage(message: state.message, onRetry: _load)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ServiceDetailsMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ServiceDetailsMessage({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    // Kept scrollable so pull-to-refresh still works on failure.
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
          SizedBox(height: 1.5.h),
          Center(
            child: TextButton(onPressed: onRetry, child: const Text('Retry')),
          ),
        ],
      ),
    );
  }
}
