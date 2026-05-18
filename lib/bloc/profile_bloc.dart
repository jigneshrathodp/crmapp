import 'package:flutter_bloc/flutter_bloc.dart';

import '../all_api_calls/all_api_calls.dart';
import '../events/profile_events.dart';
import '../states/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AllApiCalls _apiCalls;

  ProfileBloc(this._apiCalls) : super(ProfileState()) {
    on<GetProfileDetails>(_onGetProfileDetails);
    on<UpdateProfile>(_onUpdateProfile);
    on<ResetPassword>(_onResetPassword);
  }

  Future<void> _onGetProfileDetails(
    GetProfileDetails event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final profile = await _apiCalls.getProfileDetails();
      emit(state.copyWith(isLoading: false, profileDetails: profile));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final updated = await _apiCalls.updateProfile(event.data);
      emit(state.copyWith(isLoading: false, profileDetails: updated));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onResetPassword(
    ResetPassword event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _apiCalls.resetPassword(event.data);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
