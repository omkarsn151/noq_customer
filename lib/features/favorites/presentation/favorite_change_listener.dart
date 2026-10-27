import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/common/app_snackbar.dart';
import 'package:noq/features/favorites/bloc/favorite_bloc.dart';
import 'package:noq/features/favorites/bloc/favorite_state.dart';

/// Reacts to save/clear results from the app-wide [FavoriteBloc].
///
/// Every screen in the stack listens, so the snackbar is shown only by the
/// visible route; screens underneath just patch their hearts via [onChanged].
class FavoriteChangeListener extends StatelessWidget {
  /// Whether a change to this business matters to the screen.
  final bool Function(String businessId) isRelevant;

  /// Called after a successful save/clear of a relevant business.
  final void Function(String businessId, bool isFavorited) onChanged;

  final Widget child;

  const FavoriteChangeListener({
    super.key,
    required this.isRelevant,
    required this.onChanged,
    required this.child,
  });

  bool _isVisible(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent ?? true;

  void _listener(BuildContext context, FavoriteState state) {
    switch (state) {
      case FavoriteSuccess(
            :final businessId,
            :final isFavorited,
            :final message,
          )
          when isRelevant(businessId):
        if (_isVisible(context)) {
          isFavorited
              ? AppSnackbar.success(context, message)
              : AppSnackbar.info(context, message);
        }
        onChanged(businessId, isFavorited);
      case FavoriteFailure(:final businessId, :final message)
          when isRelevant(businessId):
        if (_isVisible(context)) AppSnackbar.error(context, message);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteBloc, FavoriteState>(
      listener: _listener,
      child: child,
    );
  }
}
