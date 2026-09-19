import 'package:flutter/material.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/common/app_button.dart';
import 'package:noq/features/dummy/service_slot.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';

class _CartItem {
  final String name;
  final String description;
  final String date;
  final String time;
  final String originalPrice;
  final String price;
  int quantity = 1;

  _CartItem({
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    required this.originalPrice,
    required this.price,
  });
}

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late List<_CartItem> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      _CartItem(
        name: "Classic Men's Fade",
        description: 'Low fade styling',
        date: 'Today',
        time: '10:00 Am',
        originalPrice: '₹55',
        price: '₹45',
      ),
      _CartItem(
        name: 'Hair Wash & Blow Dry',
        description: 'Anti-Dandruff Wash',
        date: 'Today',
        time: '10:00 Am',
        originalPrice: '₹15',
        price: '₹25',
      ),
      _CartItem(
        name: 'Hair Coloring',
        description: 'Instant Hair Color',
        date: 'Today',
        time: '10:00 Am',
        originalPrice: '₹45',
        price: '₹35',
      ),
    ];
  }

  int get _totalServices => _items.length;
  double get _subtotal => 105.0;
  double get _discount => 2.0;
  double get _taxes => 5.0;
  double get _platformFee => 5.0;
  double get _totalPayable => 117.0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppAppBar(title: 'Cart', showLeading: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < _items.length; i++) ...[
                _CartItemTile(
                  item: _items[i],
                  onQuantityChanged: (qty) {
                    setState(() => _items[i].quantity = qty);
                  },
                ),
                if (i != _items.length - 1)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    child: Divider(height: 1, color: AppColors.borderLight),
                  ),
              ],
              SizedBox(height: 3.h),
              Text('Payment Summary', style: textTheme.titleMedium),
              SizedBox(height: 2.h),
              _SummaryRow(
                label: 'Total No. of Services',
                value: '$_totalServices Services',
                textTheme: textTheme,
              ),
              SizedBox(height: 1.5.h),
              _SummaryRow(
                label: 'Subtotal',
                value: '₹${_subtotal.toStringAsFixed(0)}',
                textTheme: textTheme,
              ),
              SizedBox(height: 1.5.h),
              _SummaryRow(
                label: 'Discount',
                value: '₹${_discount.toStringAsFixed(0)}',
                textTheme: textTheme,
              ),
              SizedBox(height: 1.5.h),
              _SummaryRow(
                label: 'Taxes',
                value: '₹${_taxes.toStringAsFixed(0)}',
                textTheme: textTheme,
              ),
              SizedBox(height: 1.5.h),
              _SummaryRow(
                label: 'Platform Fee',
                value: '₹${_platformFee.toStringAsFixed(0)}',
                textTheme: textTheme,
              ),
              SizedBox(height: 2.h),
              Divider(height: 1, color: AppColors.borderLight),
              SizedBox(height: 2.h),
              _SummaryRow(
                label: 'Total Payable',
                value: '₹${_totalPayable.toStringAsFixed(0)}',
                textTheme: textTheme,
                isBold: true,
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Text(
                    '$_totalServices Services',
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 40.w,
                    child: AppButton(
                      label: 'Proceed To Pay',
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(builder: (_) => ServiceSlot()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final _CartItem item;
  final Function(int) onQuantityChanged;

  const _CartItemTile({required this.item, required this.onQuantityChanged});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.sp),
          child: Image.asset(
            AppAssets.serviceThumbnail,
            width: 15.w,
            height: 20.w,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.4.h),
              Text(
                item.description,
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
              item.price,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sp),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.delete_outline_rounded, size: 17.sp),
                  Text('Remove', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final TextTheme textTheme;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.textTheme,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
