import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';

class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const AppSearchField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasQuery = controller?.text.isNotEmpty ?? false;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.w),
      borderSide: const BorderSide(color: AppColors.primary),
    );

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText ?? 'Search',
        hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary.withValues(alpha: 0.5)),
        prefixIcon: Icon(Icons.search, color: AppColors.primary, size: 18.sp),
        suffixIcon: hasQuery
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: AppColors.textSecondary,
                  size: 17.sp,
                ),
                onPressed: onClear,
              )
            : null,
        filled: true,
        fillColor: AppColors.background,
        contentPadding: EdgeInsets.symmetric(vertical: 1.7.h),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
      ),
    );
  }
}