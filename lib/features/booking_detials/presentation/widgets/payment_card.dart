import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/booking_detials/presentation/widgets/amount_row.dart';
import 'package:noq/features/booking_detials/presentation/widgets/details_card.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: replace placeholder amounts with booking payment data.
    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTitle('Payment Summary'),
          SizedBox(height: 1.h),
          const AmountRow(label: 'Subtotal', value: '₹800'),
          const AmountRow(
            label: 'Discount',
            value: '-₹80',
            valueColor: AppColors.success,
          ),
          SizedBox(height: 1.h),
          const Divider(height: 1, thickness: 1, color: AppColors.borderLight),
          SizedBox(height: 1.h),
          const AmountRow(label: 'Total', value: '₹720', emphasised: true),
        ],
      ),
    );
  }
}
