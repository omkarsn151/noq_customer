import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:noq/features/promo/data/promo_model.dart';
import 'package:noq/features/promo/presentation/widgets/promo_card.dart';

/// Placeholder offer cards shown in the promo sheet while offers load.
class PromoLoadingWidget extends StatelessWidget {
  const PromoLoadingWidget({super.key});

  static const _placeholder = PromoOfferModel(
    id: '',
    code: 'CODE000',
    title: 'Promo title placeholder',
    description: 'Promo description placeholder',
    discountType: PromoDiscountType.flat,
    discountValue: '000.00',
    maxDiscountAmount: null,
    minBookingAmount: null,
    validFrom: null,
    validUntil: null,
    isApplicable: true,
    unavailableReason: null,
    estimatedSavings: '000.00',
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (_, _) => SizedBox(height: 1.3.h),
        itemBuilder: (_, _) => PromoCard(
          promo: _placeholder,
          isSelected: false,
          isApplying: false,
          isRemoving: false,
          onApply: () {},
          onRemove: null,
        ),
      ),
    );
  }
}
