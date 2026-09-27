import 'package:equatable/equatable.dart';
import 'package:noq/features/promo/data/promo_model.dart';

/// Sentinel used by [PromoLoaded.copyWith] so that nullable fields can be
/// cleared as well as replaced.
const Object _unset = Object();

abstract class PromoState extends Equatable {
  const PromoState();

  @override
  List<Object?> get props => [];
}

class PromoInitial extends PromoState {
  const PromoInitial();
}

class PromoLoading extends PromoState {
  const PromoLoading();
}

class PromoLoaded extends PromoState {
  final CartPromosModel promos;

  /// Id of the offer whose apply call is in flight; null when idle. Only that
  /// card shows a spinner, and every other action is disabled meanwhile.
  final String? applyingPromoId;

  /// True while the remove call is in flight.
  final bool isRemoving;

  /// Message for a failed apply or remove, shown as a snackbar so the sheet
  /// stays open; a first-load failure emits [PromoFailure] instead.
  final String? actionError;

  /// Set once an apply or remove succeeds. The sheet listens for this to close
  /// itself, refresh the cart and show a snackbar.
  final String? actionMessage;

  const PromoLoaded({
    required this.promos,
    this.applyingPromoId,
    this.isRemoving = false,
    this.actionError,
    this.actionMessage,
  });

  /// True while either call is in flight — used to disable the other cards.
  bool get isBusy => applyingPromoId != null || isRemoving;

  PromoLoaded copyWith({
    CartPromosModel? promos,
    Object? applyingPromoId = _unset,
    bool? isRemoving,
    Object? actionError = _unset,
    Object? actionMessage = _unset,
  }) {
    return PromoLoaded(
      promos: promos ?? this.promos,
      applyingPromoId: identical(applyingPromoId, _unset)
          ? this.applyingPromoId
          : applyingPromoId as String?,
      isRemoving: isRemoving ?? this.isRemoving,
      actionError: identical(actionError, _unset)
          ? this.actionError
          : actionError as String?,
      actionMessage: identical(actionMessage, _unset)
          ? this.actionMessage
          : actionMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    // CartPromosModel is a plain model, so compare the fields the sheet reads.
    promos.promos
        .map((e) => '${e.id}|${e.isApplicable}|${e.estimatedSavings}')
        .toList(),
    promos.selectedPromoId,
    applyingPromoId,
    isRemoving,
    actionError,
    actionMessage,
  ];
}

class PromoFailure extends PromoState {
  final String message;

  const PromoFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
