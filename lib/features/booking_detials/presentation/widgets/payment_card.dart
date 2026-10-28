import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/booking_detials/data/booking_details_model.dart';
import 'package:noq/features/booking_detials/presentation/widgets/amount_row.dart';
import 'package:noq/features/booking_detials/presentation/widgets/details_card.dart';

/// Payment Summary. There is no paid / unpaid state — never draw a badge.
class PaymentCard extends StatelessWidget {
  final BookingDetailsPayment payment;

  const PaymentCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final promo = payment.promo;

    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTitle('Payment Summary'),
          SizedBox(height: 1.h),
          AmountRow(label: 'Subtotal', value: payment.format(payment.subtotal)),
          if (payment.hasDiscount)
            AmountRow(
              label: promo == null
                  ? 'Discount'
                  : 'Discount (${promo.code} · ${promo.label})',
              value: '-${payment.format(payment.discount)}',
              valueColor: AppColors.success,
            ),
          SizedBox(height: 1.h),
          const Divider(height: 1, thickness: 1, color: AppColors.borderLight),
          SizedBox(height: 1.h),
          AmountRow(
            label: 'Total',
            value: payment.format(payment.total),
            emphasised: true,
          ),
        ],
      ),
    );
  }
}
