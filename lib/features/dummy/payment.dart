import 'package:flutter/material.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:sizer/sizer.dart';

class Payment extends StatelessWidget {
  const Payment({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppAppBar(title: 'Payment'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppAssets.paymentSuccess),
            Text(
              'Payment Successful',
              style: textTheme.bodyLarge!.copyWith(fontSize: 18.sp),
            ),
            const SizedBox(height: 10),
            Text(
              'We\'ve received your payment and your service is now confirmed.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
