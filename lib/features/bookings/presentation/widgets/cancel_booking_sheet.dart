import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_button.dart';
import 'package:noq/core/common/app_text_field.dart';
import 'package:noq/core/utils/app_colors.dart';

/// Asks for an optional cancellation note.
///
/// `null` means the sheet was dismissed (abort); `''` means the customer
/// confirmed without typing anything (cancel with no reason).
class CancelBookingSheet {
  CancelBookingSheet._();

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.13.w)),
      ),
      builder: (_) => const _CancelBookingSheetBody(),
    );
  }
}

class _CancelBookingSheetBody extends StatefulWidget {
  const _CancelBookingSheetBody();

  @override
  State<_CancelBookingSheetBody> createState() =>
      _CancelBookingSheetBodyState();
}

class _CancelBookingSheetBodyState extends State<_CancelBookingSheetBody> {
  final _controller = TextEditingController();

  /// A second pop from a double tap would close the screen underneath.
  bool _closed = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close([String? result]) {
    if (_closed) return;
    _closed = true;
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          4.62.w,
          1.42.h,
          4.62.w,
          2.13.h + MediaQuery.viewInsetsOf(context).bottom,
        ),
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
            Text(
              'Cancel Booking',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 0.4.h),
            Text(
              'The shop will see your note. Cancelling close to your '
              'appointment time may incur a late cancellation fee as per the '
              "shop's policy.",
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 1.9.h),
            AppTextField(
              controller: _controller,
              hintText: 'Reason (optional)',
              minLines: 3,
              maxLines: 4,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
            ),
            SizedBox(height: 1.5.h),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Cancel Booking',
                backgroundColor: AppColors.error,
                onPressed: () => _close(_controller.text.trim()),
              ),
            ),
            SizedBox(height: 0.5.h),
            Center(
              child: TextButton(
                onPressed: _close,
                child: const Text('Keep Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
