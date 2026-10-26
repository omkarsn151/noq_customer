import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/business_details/bloc/business_details_bloc.dart';
import 'package:noq/features/business_details/bloc/business_details_event.dart';
import 'package:noq/features/business_details/bloc/business_details_state.dart';
import 'package:noq/features/business_details/data/business_details_model.dart';
import 'package:noq/features/business_details/presentation/widgets/business_header_section.dart';
import 'package:noq/features/business_details/presentation/widgets/business_info_section.dart';
import 'package:noq/features/business_details/presentation/widgets/customer_reviews_section.dart';
import 'package:noq/features/business_details/presentation/widgets/popular_services_section.dart';

class BusinessDetailsScreen extends StatefulWidget {
  final String businessId;

  const BusinessDetailsScreen({super.key, required this.businessId});

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<BusinessDetailsBloc>().add(
      BusinessDetailsRequested(widget.businessId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<BusinessDetailsBloc, BusinessDetailsState>(
        listenWhen: (_, current) =>
            current is BusinessDetailsNotFound &&
            current.businessId == widget.businessId,
        listener: (context, state) {
          // The shop is no longer public — leave instead of retrying.
          AppSnackbar.show(
            context,
            message: 'This business is no longer available.',
            type: AppSnackBarType.error,
          );
          context.pop();
        },
        builder: (context, state) {
          // The bloc is app-wide, so ignore a previously opened business.
          if (state is BusinessDetailsLoaded &&
              state.details.id == widget.businessId) {
            return _BusinessDetailsBody(details: state.details);
          }
          if (state is BusinessDetailsFailure) {
            return _BusinessDetailsMessage(
              message: state.message,
              onRetry: _load,
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _BusinessDetailsBody extends StatelessWidget {
  final BusinessDetailsModel details;

  const _BusinessDetailsBody({required this.details});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BusinessHeaderSection(
            heroUrl: details.business.heroUrl,
            isFavorited: details.isFavorited,
          ),
          SizedBox(height: 2.h),
          BusinessInfoSection(
            business: details.business,
            rating: details.rating,
            wait: details.wait,
            location: details.location,
          ),
          if (details.services.items.isNotEmpty) ...[
            SizedBox(height: 4.h),
            PopularServicesSection(services: details.services.items),
          ],
          if (details.reviews.isNotEmpty) ...[
            SizedBox(height: 4.h),
            CustomerReviewsSection(
              businessId: details.id,
              reviews: details.reviews,
              rating: details.rating,
            ),
          ],
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}

class _BusinessDetailsMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _BusinessDetailsMessage({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
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
