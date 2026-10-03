import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/features/cart/bloc/cart_bloc.dart';
import 'package:noq/features/cart/bloc/cart_event.dart';
import 'package:noq/features/cart/bloc/cart_state.dart';
import 'package:noq/features/cart/presentation/widgets/cart_content.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(const CartItemsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'Cart', showLeading: false),
      body: BlocConsumer<CartBloc, CartState>(
        listenWhen: (previous, current) => current is CartItemRemoveFailure,
        listener: (context, state) {
          if (state is CartItemRemoveFailure) {
            AppSnackbar.error(context, state.message);
          }
        },
        buildWhen: (previous, current) => current is! CartItemRemoveFailure,
        builder: (context, state) {
          if (state is CartLoading || state is CartInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );
          }

          final loadedState = state as CartLoaded;
          final cart = loadedState.cart;

          if (cart.items.isEmpty) {
            return Center(
              child: Text(
                'Your cart is empty',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CartBloc>().add(const CartItemsRequested());
            },
            child: CartContent(
              cart: cart,
              removingItemId: loadedState.removingItemId,
            ),
          );
        },
      ),
    );
  }
}
