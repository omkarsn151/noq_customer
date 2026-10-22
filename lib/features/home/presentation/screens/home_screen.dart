import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_button.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/home/bloc/home_bloc.dart';
import 'package:noq/features/home/bloc/home_event.dart';
import 'package:noq/features/home/bloc/home_state.dart';
import 'package:noq/features/home/data/home_model.dart';
import 'package:noq/features/home/presentation/widgets/home_app_bar.dart';
import 'package:noq/features/home/presentation/widgets/up_next_section.dart';
import 'package:noq/features/home/presentation/widgets/categories_section.dart';
import 'package:noq/features/home/presentation/widgets/special_offers_section.dart';
import 'package:noq/features/home/presentation/widgets/nearby_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const HomeRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async =>
            context.read<HomeBloc>().add(const HomeRequested(refresh: true)),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const HomeAppBar(),
              SizedBox(height: 2.h),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoaded) {
                    return _HomeContent(home: state.home);
                  }

                  if (state is HomeFailure) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 4.h,
                      ),
                      child: Column(
                        children: [
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 2.h),
                          AppButton(
                            label: 'Retry',
                            onPressed: () => context.read<HomeBloc>().add(
                              const HomeRequested(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final HomeModel home;

  const _HomeContent({required this.home});

  @override
  Widget build(BuildContext context) {
    final upNext = home.upNext;
    return Column(
      children: [
        if (upNext != null) ...[
          UpNextSection(upNext: upNext),
          SizedBox(height: 3.h),
        ],
        if (home.categories.items.isNotEmpty) ...[
          CategoriesSection(categories: home.categories),
          SizedBox(height: 3.h),
        ],
        // Always empty until promotional banners land on the backend.
        if (home.specialOffers.items.isNotEmpty) ...[
          const SpecialOffersSection(),
          SizedBox(height: 3.h),
        ],
        NearbySection(nearby: home.nearby),
        SizedBox(height: 3.h),
      ],
    );
  }
}
