import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/promo/bloc/promo_event.dart';
import 'package:noq/features/promo/bloc/promo_state.dart';
import 'package:noq/features/promo/data/promo_model.dart';
import 'package:noq/features/promo/repository/promo_repository.dart';

class PromoBloc extends Bloc<PromoEvent, PromoState> {
  final PromoRepository _repository;

  PromoBloc(this._repository) : super(const PromoInitial()) {
    on<PromoListRequested>(_onPromoListRequested);
    on<PromoApplyRequested>(_onPromoApplyRequested);
    on<PromoRemoveRequested>(_onPromoRemoveRequested);
  }

  Future<void> _onPromoListRequested(
    PromoListRequested event,
    Emitter<PromoState> emit,
  ) async {
    emit(const PromoLoading());

    try {
      final promos = await _repository.getCartPromos();
      emit(PromoLoaded(promos: promos));
    } on ApiException catch (e) {
      emit(PromoFailure(message: e.message));
    } catch (e) {
      emit(PromoFailure(message: e.toString()));
    }
  }

  Future<void> _onPromoApplyRequested(
    PromoApplyRequested event,
    Emitter<PromoState> emit,
  ) async {
    final current = state;
    if (current is! PromoLoaded || current.isBusy) return;

    emit(
      current.copyWith(
        applyingPromoId: event.promoId,
        actionError: null,
        actionMessage: null,
      ),
    );

    try {
      final result = await _repository.applyPromo(event.promoId);
      _emitActionSuccess(emit, result, 'Promo applied successfully.');
    } on ApiException catch (e) {
      _emitActionError(emit, e.message);
    } catch (e) {
      _emitActionError(emit, e.toString());
    }
  }

  Future<void> _onPromoRemoveRequested(
    PromoRemoveRequested event,
    Emitter<PromoState> emit,
  ) async {
    final current = state;
    if (current is! PromoLoaded || current.isBusy) return;

    emit(
      current.copyWith(
        isRemoving: true,
        actionError: null,
        actionMessage: null,
      ),
    );

    try {
      final result = await _repository.removePromo();
      _emitActionSuccess(emit, result, 'Promo removed successfully.');
    } on ApiException catch (e) {
      _emitActionError(emit, e.message);
    } catch (e) {
      _emitActionError(emit, e.toString());
    }
  }

  /// Folds the ack's new selection and payment numbers back into the loaded
  /// state. The other offers keep their old `estimated_savings` — the sheet
  /// closes on success and re-fetches on the next open.
  void _emitActionSuccess(
    Emitter<PromoState> emit,
    PromoSelectionModel result,
    String message,
  ) {
    final latest = state;
    if (latest is! PromoLoaded) return;

    emit(
      latest.copyWith(
        promos: CartPromosModel(
          promos: latest.promos.promos,
          selectedPromoId: result.selectedPromo?.id,
          paymentSummary: result.paymentSummary,
        ),
        applyingPromoId: null,
        isRemoving: false,
        actionMessage: message,
      ),
    );
  }

  void _emitActionError(Emitter<PromoState> emit, String message) {
    final latest = state;
    if (latest is! PromoLoaded) return;

    emit(
      latest.copyWith(
        applyingPromoId: null,
        isRemoving: false,
        actionError: message,
      ),
    );
  }
}
