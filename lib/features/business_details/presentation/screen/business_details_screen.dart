import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/business_details/bloc/business_details_bloc.dart';
import 'package:noq/features/business_details/bloc/business_details_event.dart';
import 'package:noq/features/business_details/bloc/business_details_state.dart';
import 'package:noq/features/business_details/data/business_details_model.dart';
import 'package:noq/features/business_details/repository/business_details_repository.dart';
import 'package:noq/features/cart/bloc/add_to_cart_bloc.dart';
import 'package:noq/features/cart/bloc/add_to_cart_event.dart';
import 'package:noq/features/cart/bloc/add_to_cart_state.dart';
import 'package:noq/features/cart/bloc/cart_bloc.dart';
import 'package:noq/features/cart/bloc/cart_event.dart';

class BusinessDetailsScreen extends StatelessWidget {
  final String businessId;

  const BusinessDetailsScreen({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BusinessDetailsBloc>(
      create: (_) => BusinessDetailsBloc(BusinessDetailsRepository())
        ..add(BusinessDetailsRequested(businessId)),
      child: const _BusinessDetailsView(),
    );
  }
}

class _BusinessDetailsView extends StatelessWidget {
  const _BusinessDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BusinessDetailsBloc, BusinessDetailsState>(
        builder: (context, state) {
          if (state is BusinessDetailsLoading || state is BusinessDetailsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BusinessDetailsFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );
          }

          final details = (state as BusinessDetailsLoaded).details;
          return _BusinessDetailsContent(details: details);
        },
      ),
    );
  }
}

class _BusinessDetailsContent extends StatelessWidget {
  final BusinessDetailsModel details;

  const _BusinessDetailsContent({required this.details});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(heroUrl: details.business.heroUrl),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        details.business.name,
                        style: textTheme.headlineLarge,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    _DetailsButton(),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        details.business.services.join(', '),
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _CircleIconButton(
                      icon: Icons.call_rounded,
                      onTap: () => _launchPhoneAction(
                        context,
                        scheme: 'tel',
                        phone: details.business.phone,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    _CircleIconButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      onTap: () => _launchPhoneAction(
                        context,
                        scheme: 'sms',
                        phone: details.business.phone,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Row(
                  children: [
                    _Pill(
                      icon: Icons.star_rounded,
                      iconColor: Colors.amber,
                      label:
                          '${details.rating.average.toStringAsFixed(1)} (${details.rating.totalReviews})',
                    ),
                    SizedBox(width: 2.w),
                    _Pill(
                      icon: Icons.access_time_rounded,
                      iconColor: AppColors.primary,
                      label: '${details.wait.minutes} MIN WAIT',
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                if (details.services.isNotEmpty) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Popular Services',
                          style: textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        'See all',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  for (int i = 0; i < details.services.length; i++) ...[
                    _ServiceTile(service: details.services[i]),
                    if (i != details.services.length - 1)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        child: Divider(height: 1, color: AppColors.borderLight),
                      ),
                  ],
                ],
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String heroUrl;

  const _Header({required this.heroUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.sp),
            bottomRight: Radius.circular(24.sp),
          ),
          child: heroUrl.isEmpty
              ? Image.asset(
                  AppAssets.businessThumbnail,
                  width: double.infinity,
                  height: 30.h,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  heroUrl,
                  width: double.infinity,
                  height: 30.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    AppAssets.businessThumbnail,
                    width: double.infinity,
                    height: 30.h,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        Positioned(
          top: 6.h,
          left: 4.w,
          child: _CircleOverlayButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        Positioned(
          top: 6.h,
          right: 4.w,
          child: Row(
            children: [
              _CircleOverlayButton(icon: Icons.send_rounded),
              SizedBox(width: 2.w),
              _CircleOverlayButton(
                icon: Icons.favorite_rounded,
                iconColor: AppColors.error,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircleOverlayButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _CircleOverlayButton({required this.icon, this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        padding: EdgeInsets.all(2.6.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: iconColor ?? AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2.4.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Icon(icon, size: 16.sp, color: AppColors.primary),
      ),
    );
  }
}

class _DetailsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.sp),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 14.sp,
            color: AppColors.textPrimary,
          ),
          SizedBox(width: 1.w),
          Text('Details', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const _Pill({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
      decoration: BoxDecoration(
        color: AppColors.pink,
        borderRadius: BorderRadius.circular(20.sp),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: iconColor),
          SizedBox(width: 1.w),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final BusinessServiceModel service;

  const _ServiceTile({required this.service});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.sp),
          child: service.thumbnailUrl.isEmpty
              ? Image.asset(
                  AppAssets.serviceThumbnail,
                  width: 18.w,
                  height: 25.w,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  service.thumbnailUrl,
                  width: 18.w,
                  height: 25.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    AppAssets.serviceThumbnail,
                    width: 18.w,
                    height: 25.w,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(service.name, style: textTheme.bodyLarge),
              SizedBox(height: 0.4.h),
              Text(
                service.description,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pink,
                      borderRadius: BorderRadius.circular(20.sp),
                    ),
                    child: Text(
                      '${service.durationMinutes} min',
                      style: textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _CartToggleButton(
                    key: ValueKey(service.id),
                    serviceId: service.id,
                    isInCart: service.isInCart,
                    cartItemId: service.cartItemId,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 2.w),
        Text('₹${service.pricing.price}', style: textTheme.bodyLarge),
      ],
    );
  }
}

class _CartToggleButton extends StatefulWidget {
  final String serviceId;
  final bool isInCart;
  final String? cartItemId;

  const _CartToggleButton({
    super.key,
    required this.serviceId,
    required this.isInCart,
    required this.cartItemId,
  });

  @override
  State<_CartToggleButton> createState() => _CartToggleButtonState();
}

class _CartToggleButtonState extends State<_CartToggleButton> {
  /// Cart membership is tracked locally so the button can flip immediately
  /// after an add/remove without refetching the whole business details screen.
  late bool _isInCart = widget.isInCart;
  late String? _cartItemId = widget.cartItemId;

  @override
  void didUpdateWidget(covariant _CartToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isInCart != widget.isInCart ||
        oldWidget.cartItemId != widget.cartItemId) {
      _isInCart = widget.isInCart;
      _cartItemId = widget.cartItemId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddToCartBloc, AddToCartState>(
      listenWhen: (previous, current) =>
          (current is AddToCartSuccess &&
              current.serviceId == widget.serviceId) ||
          (current is AddToCartFailure &&
              current.serviceId == widget.serviceId) ||
          (current is RemoveFromCartSuccess &&
              current.serviceId == widget.serviceId) ||
          (current is RemoveFromCartFailure &&
              current.serviceId == widget.serviceId),
      listener: (context, state) {
        if (state is AddToCartSuccess) {
          setState(() => _isInCart = true);
          AppSnackbar.success(context, state.message);
          // Keep the cart tab in sync with what was just added.
          context.read<CartBloc>().add(const CartItemsRequested());
        } else if (state is RemoveFromCartSuccess) {
          setState(() {
            _isInCart = false;
            _cartItemId = null;
          });
          AppSnackbar.success(context, state.message);
          context.read<CartBloc>().add(const CartItemsRequested());
        } else if (state is AddToCartFailure) {
          AppSnackbar.error(context, state.message);
        } else if (state is RemoveFromCartFailure) {
          AppSnackbar.error(context, state.message);
        }
      },
      child: BlocBuilder<AddToCartBloc, AddToCartState>(
        builder: (context, state) {
          final isLoading =
              (state is AddToCartLoading &&
                  state.serviceId == widget.serviceId) ||
              (state is RemoveFromCartLoading &&
                  state.serviceId == widget.serviceId);

          final borderColor = _isInCart
              ? AppColors.textSecondary
              : AppColors.primary;

          return InkWell(
            borderRadius: BorderRadius.circular(12.sp),
            onTap: isLoading
                ? null
                : () {
                    final bloc = context.read<AddToCartBloc>();
                    final cartItemId = _cartItemId;
                    if (_isInCart) {
                      if (cartItemId == null) return;
                      bloc.add(
                        RemoveFromCartRequested(
                          serviceId: widget.serviceId,
                          cartItemId: cartItemId,
                        ),
                      );
                    } else {
                      bloc.add(AddToCartRequested(serviceId: widget.serviceId));
                    }
                  },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.sp),
                border: Border.all(color: borderColor, width: 1.5),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 14.sp,
                      height: 14.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: borderColor,
                      ),
                    )
                  : Text(
                      _isInCart ? 'REMOVE FROM CART' : 'ADD TO CART',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
            ),
          );
        },
      ),
    );
  }
}

/// Opens the dialer (`tel`) or the SMS composer (`sms`) for [phone].
Future<void> _launchPhoneAction(
  BuildContext context, {
  required String scheme,
  required String phone,
}) async {
  // Dial/SMS URIs only tolerate digits and a leading '+'.
  final sanitized = phone.replaceAll(RegExp(r'[^\d+]'), '');

  if (sanitized.isEmpty) {
    AppSnackbar.error(context, 'No phone number available.');
    return;
  }

  var launched = false;
  try {
    launched = await launchUrl(Uri(scheme: scheme, path: sanitized));
  } catch (_) {
    // No app on the device handles the scheme; fall through to the error below.
  }

  if (!launched && context.mounted) {
    AppSnackbar.error(
      context,
      scheme == 'tel'
          ? 'Could not open the dialer.'
          : 'Could not open messages.',
    );
  }
}
