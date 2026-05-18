import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../all_api_calls/all_api_calls.dart';
import '../events/auth_events.dart';
import '../states/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AllApiCalls _apiCalls;

  AuthBloc(this._apiCalls) : super(AuthState()) {
    on<Login>(_onLogin);
    on<Logout>(_onLogout);
  }

  Future<void> _onLogin(Login event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final response = await _apiCalls.login(event.data);
      if (response['status'] == true && response['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response['token']);
        emit(
          state.copyWith(
            isLoading: false,
            isLoggedIn: true,
            token: response['token'],
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: response['message'] ?? 'Login failed',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLogout(Logout event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _apiCalls.logout();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      emit(state.copyWith(isLoading: false, isLoggedIn: false, token: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
