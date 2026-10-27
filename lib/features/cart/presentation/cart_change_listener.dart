import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/features/cart/bloc/add_to_cart_bloc.dart';
import 'package:noq/features/cart/bloc/add_to_cart_state.dart';

/// Reacts to add/remove results from the app-wide [AddToCartBloc].
///
/// Every screen in the stack listens, so the snackbar is shown only by the
/// visible route; screens underneath just refresh their data via [onChanged].
class CartChangeListener extends StatelessWidget {
  /// Whether a change to this service matters to the screen.
  final bool Function(String serviceId) isRelevant;

  /// Called after a successful add/remove of a relevant service.
  final void Function(String serviceId) onChanged;

  final Widget child;

  const CartChangeListener({
    super.key,
    required this.isRelevant,
    required this.onChanged,
    required this.child,
  });

  bool _isVisible(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent ?? true;

  void _listener(BuildContext context, AddToCartState state) {
    switch (state) {
      case AddToCartSuccess(:final serviceId, :final message) ||
              RemoveFromCartSuccess(:final serviceId, :final message)
          when isRelevant(serviceId):
        if (_isVisible(context)) AppSnackbar.success(context, message);
        onChanged(serviceId);
      case AddToCartFailure(:final serviceId, :final message) ||
              RemoveFromCartFailure(:final serviceId, :final message)
          when isRelevant(serviceId):
        if (_isVisible(context)) AppSnackbar.error(context, message);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddToCartBloc, AddToCartState>(
      listener: _listener,
      child: child,
    );
  }
}
