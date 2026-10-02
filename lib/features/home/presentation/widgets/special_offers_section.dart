import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';

class _OfferItem {
  final String badge;
  final String title;
  final String image;

  const _OfferItem({
    required this.badge,
    required this.title,
    required this.image,
  });
}

class SpecialOffersSection extends StatefulWidget {
  const SpecialOffersSection({super.key});

  @override
  State<SpecialOffersSection> createState() => _SpecialOffersSectionState();
}

class _SpecialOffersSectionState extends State<SpecialOffersSection> {
  final PageController _controller = PageController(viewportFraction: 1);
  int _currentPage = 0;

  static const List<_OfferItem> _offers = [
    _OfferItem(
      badge: 'Slash deal',
      title: 'Get 40% Off on any Salon Services',
      image: AppAssets.specialOffer1,
    ),
    _OfferItem(
      badge: 'Limited time',
      title: 'Flat 25% Off on your first DMV visit',
      image: AppAssets.specialOffer2,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Special Offers',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View All',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.5.h),
        SizedBox(
          height: 18.h,
          child: PageView.builder(
            controller: _controller,
            itemCount: _offers.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            padEnds: false,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: _OfferCard(item: _offers[index]),
            ),
          ),
        ),
        SizedBox(height: 1.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _offers.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 0.8.w),
              height: 0.9.h,
              width: _currentPage == index ? 5.w : 0.9.h,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primary
                    : AppColors.borderLight,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OfferCard extends StatelessWidget {
  final _OfferItem item;

  const _OfferCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.w),
      child: Image.asset(item.image, fit: BoxFit.contain),
    );
  }
}
