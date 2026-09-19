import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/common/app_button.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/cart/bloc/cart_bloc.dart';
import 'package:noq/features/cart/bloc/cart_event.dart';
import 'package:noq/features/cart/bloc/cart_state.dart';
import 'package:noq/features/cart/data/cart_model.dart';
import 'package:noq/features/slot/presentation/screens/slot_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(const CartItemsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'Cart', showLeading: false),
      body: BlocConsumer<CartBloc, CartState>(
        listenWhen: (previous, current) => current is CartItemRemoveFailure,
        listener: (context, state) {
          if (state is CartItemRemoveFailure) {
            AppSnackbar.error(context, state.message);
          }
        },
        buildWhen: (previous, current) => current is! CartItemRemoveFailure,
        builder: (context, state) {
          if (state is CartLoading || state is CartInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartFailure) {
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

          final loadedState = state as CartLoaded;
          final cart = loadedState.cart;

          if (cart.items.isEmpty) {
            return Center(
              child: Text(
                'Your cart is empty',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CartBloc>().add(const CartItemsRequested());
            },
            child: _CartContent(
              cart: cart,
              removingItemId: loadedState.removingItemId,
            ),
          );
        },
      ),
    );
  }
}

class _CartContent extends StatelessWidget {
  final CartModel cart;
  final String? removingItemId;

  const _CartContent({required this.cart, this.removingItemId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final summary = cart.paymentSummary;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < cart.items.length; i++) ...[
                    _CartItemTile(
                      item: cart.items[i],
                      isRemoving: cart.items[i].id == removingItemId,
                    ),
                    if (i != cart.items.length - 1)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        child: Divider(height: 1, color: AppColors.borderLight),
                      ),
                  ],
                  SizedBox(height: 3.h),
                  Text('Payment Summary', style: textTheme.titleMedium),
                  SizedBox(height: 2.h),
                  _SummaryRow(
                    label: 'Total No. of Services',
                    value: '${summary.servicesCount} Services',
                    textTheme: textTheme,
                  ),
                  SizedBox(height: 1.5.h),
                  _SummaryRow(
                    label: 'Subtotal',
                    value: '₹${summary.subtotal}',
                    textTheme: textTheme,
                  ),
                  SizedBox(height: 1.5.h),
                  _SummaryRow(
                    label: 'Discount',
                    value: '₹${summary.discount}',
                    textTheme: textTheme,
                  ),
                  SizedBox(height: 1.5.h),
                  _SummaryRow(
                    label: 'Taxes',
                    value: '₹${summary.taxes}',
                    textTheme: textTheme,
                  ),
                  SizedBox(height: 1.5.h),
                  _SummaryRow(
                    label: 'Platform Fee',
                    value: '₹${summary.platformFee}',
                    textTheme: textTheme,
                  ),
                  SizedBox(height: 2.h),
                  Divider(height: 1, color: AppColors.borderLight),
                  SizedBox(height: 2.h),
                  _SummaryRow(
                    label: 'Total Payable',
                    value: '₹${summary.totalPayable}',
                    textTheme: textTheme,
                    isBold: true,
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
        _CheckoutBar(
          servicesCount: summary.servicesCount,
          businessId: cart.cart.business.id,
        ),
      ],
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  final int servicesCount;
  final String businessId;

  const _CheckoutBar({required this.servicesCount, required this.businessId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          Text(
            '$servicesCount Services',
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          SizedBox(
            width: 40.w,
            height: 6.h,
            child: AppButton(
              label: 'Proceed To Pay',
              onPressed: () {
                // rootNavigator: the cart lives in a shell branch, so a local
                // push would render under the bottom nav bar.
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => SlotScreen(businessId: businessId),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final bool isRemoving;

  const _CartItemTile({required this.item, required this.isRemoving});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.sp),
          child: item.service.thumbnailUrl.isEmpty
              ? Image.asset(
                  AppAssets.serviceThumbnail,
                  width: 15.w,
                  height: 20.w,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  item.service.thumbnailUrl,
                  width: 15.w,
                  height: 20.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    AppAssets.serviceThumbnail,
                    width: 15.w,
                    height: 20.w,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.service.name,
                style: textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.4.h),
              Text(
                item.service.description,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${item.pricing.price}',
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 1.h),
            InkWell(
              borderRadius: BorderRadius.circular(10.sp),
              onTap: isRemoving
                  ? null
                  : () => context.read<CartBloc>().add(
                      CartItemRemoveRequested(itemId: item.id),
                    ),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.sp),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: isRemoving
                    ? SizedBox(
                        width: 17.sp,
                        height: 17.sp,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: AppColors.primary,
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_outline_rounded, size: 17.sp),
                          Text('Remove', style: textTheme.bodySmall),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final TextTheme textTheme;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.textTheme,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
