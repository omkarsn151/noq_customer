import 'package:flutter/material.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:sizer/sizer.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? leading;
  final Widget? trailing;
  final ButtonStyle? style;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final double? height;
  final double? fontSize;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.style,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.height,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
              strokeWidth: 2,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 8)],
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor ?? AppColors.background,
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            ],
          );

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style:
          style ??
          ElevatedButton.styleFrom(
            elevation: elevation ?? 0,
            backgroundColor: backgroundColor ?? AppColors.primary,
            foregroundColor: foregroundColor ?? AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 4.w),
            ),
            minimumSize: height != null ? Size(0, height!) : null,
            padding:
                padding ??
                EdgeInsets.symmetric(
                  vertical: height != null ? 0 : 16,
                  horizontal: 20,
                ),
          ),
      child: child,
    );
  }
}
