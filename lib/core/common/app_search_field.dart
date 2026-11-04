import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';

class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;

  /// The keyboard's search action. When set, the action key reads "Search".
  final ValueChanged<String>? onSubmitted;

  final VoidCallback? onClear;
  final VoidCallback? onTap;
  final bool readOnly;

  /// Stops input past this many characters, without showing a counter.
  final int? maxLength;

  const AppSearchField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onTap,
    this.readOnly = false,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final hasQuery = controller?.text.isNotEmpty ?? false;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.w),
      borderSide: const BorderSide(color: AppColors.primary),
    );
    final maxLength = this.maxLength;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: onSubmitted == null ? null : TextInputAction.search,
      inputFormatters: maxLength == null
          ? null
          : [LengthLimitingTextInputFormatter(maxLength)],
      onTap: onTap,
      readOnly: readOnly,
      style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText ?? 'Search',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: AppColors.textSecondary.withValues(alpha: 0.5),
        ),
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
