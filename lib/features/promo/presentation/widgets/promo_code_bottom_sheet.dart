import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/cart/bloc/cart_bloc.dart';
import 'package:noq/features/cart/bloc/cart_event.dart';
import 'package:noq/features/promo/bloc/promo_bloc.dart';
import 'package:noq/features/promo/bloc/promo_event.dart';
import 'package:noq/features/promo/bloc/promo_state.dart';
import 'package:noq/features/promo/presentation/widgets/promo_card.dart';
import 'package:noq/features/promo/presentation/widgets/promo_loading_widget.dart';

class PromoCodeBottomSheet {
  PromoCodeBottomSheet._();

  static Future<void> show(BuildContext context) {
    // PromoBloc is app-global, so the fetch is dispatched per open rather than
    // once at startup: the offers are priced against the live cart.
    context.read<PromoBloc>().add(const PromoListRequested());

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      // The cart lives in a shell branch, so without this the sheet would
      // render under the bottom nav bar.
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.13.w)),
      ),
      builder: (_) => const _PromoCodeSheetBody(),
    );
  }
}

class _PromoCodeSheetBody extends StatelessWidget {
  const _PromoCodeSheetBody();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 80.h),
        child: Padding(
          padding: EdgeInsets.fromLTRB(4.62.w, 1.42.h, 4.62.w, 2.13.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 10.26.w,
                  height: 0.47.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(0.51.w),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text('Offers for you', style: textTheme.titleMedium),
              SizedBox(height: 0.4.h),
              Text(
                'Pick a code to save on this booking',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 1.9.h),
              // Header stays pinned; only the offer list scrolls.
              const Flexible(child: _PromoSheetContent()),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoSheetContent extends StatelessWidget {
  const _PromoSheetContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PromoBloc, PromoState>(
      // Both outcome fields are cleared when an action starts, so a
      // null -> value transition is what marks a fresh outcome.
      listenWhen: (previous, current) {
        if (current is! PromoLoaded) return false;
        final previousLoaded = previous is PromoLoaded ? previous : null;
        return current.actionMessage != previousLoaded?.actionMessage ||
            current.actionError != previousLoaded?.actionError;
      },
      listener: (context, state) {
        final loaded = state as PromoLoaded;

        final message = loaded.actionMessage;
        if (message != null) {
          // The cart screen owns the payment summary, so it has to re-read the
          // cart to show the new discount and total.
          context.read<CartBloc>().add(const CartItemsRequested());
          // Raised before the pop so it attaches to the app-level
          // ScaffoldMessenger and outlives this route.
          AppSnackbar.success(context, message);
          Navigator.pop(context);
          return;
        }

        final error = loaded.actionError;
        if (error != null) {
          // Sheet stays open so the customer can pick a different code.
          AppSnackbar.error(context, error);
        }
      },
      builder: (context, state) {
        if (state is PromoInitial || state is PromoLoading) {
          return const PromoLoadingWidget();
        }

        if (state is PromoFailure) {
          return _SheetPlaceholder(
            child: Text(
              state.message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        final loaded = state as PromoLoaded;
        final promos = loaded.promos;

        if (promos.promos.isEmpty) {
          return _SheetPlaceholder(
            child: Text(
              'No offers available right now',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: promos.promos.length,
          separatorBuilder: (_, _) => SizedBox(height: 1.3.h),
          itemBuilder: (context, index) {
            final promo = promos.promos[index];
            final isSelected = promo.id == promos.selectedPromoId;

            return PromoCard(
              promo: promo,
              isSelected: isSelected,
              isApplying: loaded.applyingPromoId == promo.id,
              isRemoving: isSelected && loaded.isRemoving,
              // One action at a time: a second tap while a call is in flight
              // would race the first.
              onApply: loaded.isBusy
                  ? null
                  : () => context.read<PromoBloc>().add(
                      PromoApplyRequested(promoId: promo.id),
                    ),
              onRemove: loaded.isBusy
                  ? null
                  : () => context.read<PromoBloc>().add(
                      const PromoRemoveRequested(),
                    ),
            );
          },
        );
      },
    );
  }
}

/// Keeps the sheet a stable height across the loading, error and empty states
/// so it does not jump when the list arrives.
class _SheetPlaceholder extends StatelessWidget {
  final Widget child;

  const _SheetPlaceholder({required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.h,
      width: double.infinity,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: child,
        ),
      ),
    );
  }
}
