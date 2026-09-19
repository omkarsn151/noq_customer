import 'package:flutter/material.dart';
import 'package:noq/features/business/presentation/business_lists.dart';
import 'package:sizer/sizer.dart';

class DasboardScreen extends StatelessWidget {
  const DasboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BusinessList()
            ],
          ),
        ),
      ),
    );
  }
}
