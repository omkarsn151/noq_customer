import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/cart/data/cart_model.dart';
import 'package:noq/features/cart/presentation/widgets/summary_row.dart';

class PaymentSummarySection extends StatelessWidget {
  final CartModel cart;

  const PaymentSummarySection({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    final summary = cart.paymentSummary;
    final promo = cart.promo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Summary',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 2.h),
        SummaryRow(
          label: 'Total No. of Services',
          value: '${summary.servicesCount} Services',
        ),
        SizedBox(height: 1.5.h),
        SummaryRow(label: 'Subtotal', value: '₹${summary.subtotal}'),
        SizedBox(height: 1.5.h),
        SummaryRow(
          // The code is worth naming here: the summary is the only
          // place the customer sees what the discount came from.
          label: promo == null ? 'Discount' : 'Discount (${promo.code})',
          value: summary.hasDiscount
              ? '-₹${summary.discount}'
              : '₹${summary.discount}',
          valueColor: summary.hasDiscount ? AppColors.success : null,
        ),
        SizedBox(height: 1.5.h),
        SummaryRow(label: 'Taxes', value: '₹${summary.taxes}'),
        SizedBox(height: 1.5.h),
        SummaryRow(label: 'Platform Fee', value: '₹${summary.platformFee}'),
        SizedBox(height: 2.h),
        const Divider(height: 1, color: AppColors.borderLight),
        SizedBox(height: 2.h),
        SummaryRow(
          label: 'Total Payable',
          value: '₹${summary.totalPayable}',
          isBold: true,
        ),
      ],
    );
  }
}
