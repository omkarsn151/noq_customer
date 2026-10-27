import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/favorites/bloc/favorite_event.dart';
import 'package:noq/features/favorites/bloc/favorite_state.dart';
import 'package:noq/features/favorites/repository/favorites_repository.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoritesRepository _repository;

  /// Shops with a request in flight; further taps on them are ignored.
  final Set<String> _pending = {};

  FavoriteBloc(this._repository) : super(const FavoriteInitial()) {
    on<FavoriteToggled>(_onFavoriteToggled);
  }

  Future<void> _onFavoriteToggled(
    FavoriteToggled event,
    Emitter<FavoriteState> emit,
  ) async {
    final businessId = event.businessId;
    if (!_pending.add(businessId)) return;

    emit(FavoriteLoading(businessId: businessId));
    try {
      final message = event.isFavorited
          ? await _repository.removeFavorite(businessId)
          : await _repository.addFavorite(businessId);
      emit(
        FavoriteSuccess(
          businessId: businessId,
          isFavorited: !event.isFavorited,
          message: message,
        ),
      );
    } on ApiException catch (e) {
      emit(FavoriteFailure(businessId: businessId, message: e.message));
    } catch (e) {
      emit(FavoriteFailure(businessId: businessId, message: e.toString()));
    } finally {
      _pending.remove(businessId);
    }
  }
}
