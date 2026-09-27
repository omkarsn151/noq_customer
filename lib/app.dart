import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/router/app_router.dart';
import 'package:noq/core/themes/app_theme.dart';
import 'package:noq/features/auth/register/bloc/register_bloc.dart';
import 'package:noq/features/auth/register/repository/register_repository.dart';
import 'package:noq/features/auth/request_otp/bloc/request_otp_bloc.dart';
import 'package:noq/features/auth/request_otp/repository/request_otp_repository.dart';
import 'package:noq/features/auth/verify_otp/bloc/verify_otp_bloc.dart';
import 'package:noq/features/auth/verify_otp/reopsitory/verify_otp_repository.dart';
import 'package:noq/features/bookings/bloc/bookings_bloc.dart';
import 'package:noq/features/bookings/repository/bookings_repository.dart';
import 'package:noq/features/business/bloc/business_bloc.dart';
import 'package:noq/features/business/bloc/business_event.dart';
import 'package:noq/features/business/respository/business_repository.dart';
import 'package:noq/features/business_details/bloc/business_details_bloc.dart';
import 'package:noq/features/business_details/repository/business_details_repository.dart';
import 'package:noq/features/cart/bloc/add_to_cart_bloc.dart';
import 'package:noq/features/cart/bloc/cart_bloc.dart';
import 'package:noq/features/cart/repository/cart_repository.dart';
import 'package:noq/features/promo/bloc/promo_bloc.dart';
import 'package:noq/features/promo/repository/promo_repository.dart';
import 'package:noq/features/slot/bloc/slot_bloc.dart';
import 'package:noq/features/slot/repository/slot_repository.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RequestOtpBloc>(
          create: (_) => RequestOtpBloc(RequestOtpRepository()),
        ),
        BlocProvider<VerifyOtpBloc>(
          create: (_) => VerifyOtpBloc(VerifyOtpRepository()),
        ),
        BlocProvider<RegisterBloc>(
          create: (_) => RegisterBloc(RegisterRepository()),
        ),
        BlocProvider<BusinessBloc>(
          create: (_) => BusinessBloc(BusinessRepository())
            ..add(const BusinessListRequested()),
        ),
        BlocProvider<AddToCartBloc>(
          create: (_) => AddToCartBloc(CartRepository()),
        ),
        BlocProvider<CartBloc>(create: (_) => CartBloc(CartRepository())),
        BlocProvider<BookingsBloc>(
          create: (_) => BookingsBloc(BookingsRepository()),
        ),
        BlocProvider<BusinessDetailsBloc>(
          create: (_) => BusinessDetailsBloc(BusinessDetailsRepository()),
        ),
        BlocProvider<SlotBloc>(create: (_) => SlotBloc(SlotRepository())),
        BlocProvider<PromoBloc>(create: (_) => PromoBloc(PromoRepository())),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'NoQ',
            theme: AppTheme.appTheme,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
