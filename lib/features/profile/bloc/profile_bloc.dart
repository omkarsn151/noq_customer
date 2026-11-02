import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/profile/bloc/profile_event.dart';
import 'package:noq/features/profile/bloc/profile_state.dart';
import 'package:noq/features/profile/repository/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc(this._repository) : super(const ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
  }

  Future<void> _onProfileRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final profile = await _repository.getProfile();
      emit(ProfileLoaded(profile: profile));
    } on ApiException catch (e) {
      emit(ProfileFailure(message: e.message));
    } catch (e) {
      emit(ProfileFailure(message: e.toString()));
    }
  }
}
