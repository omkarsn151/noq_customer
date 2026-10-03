import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/cart/bloc/cart_bloc.dart';
import 'package:noq/features/cart/bloc/cart_event.dart';
import 'package:noq/features/cart/data/cart_model.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final bool isRemoving;

  const CartItemTile({super.key, required this.item, required this.isRemoving});

  Widget _fallbackThumbnail() => Image.asset(
    AppAssets.serviceThumbnail,
    width: 15.w,
    height: 20.w,
    fit: BoxFit.cover,
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.sp),
          child: item.service.thumbnailUrl.isEmpty
              ? _fallbackThumbnail()
              : Image.network(
                  item.service.thumbnailUrl,
                  width: 15.w,
                  height: 20.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _fallbackThumbnail(),
                ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.service.name,
                style: textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.4.h),
              Text(
                item.service.description,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${item.pricing.price}',
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 1.h),
            InkWell(
              borderRadius: BorderRadius.circular(10.sp),
              onTap: isRemoving
                  ? null
                  : () => context.read<CartBloc>().add(
                      CartItemRemoveRequested(itemId: item.id),
                    ),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.sp),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: isRemoving
                    ? SizedBox(
                        width: 17.sp,
                        height: 17.sp,
                        child: const CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: AppColors.primary,
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_outline_rounded, size: 17.sp),
                          Text('Remove', style: textTheme.bodySmall),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
