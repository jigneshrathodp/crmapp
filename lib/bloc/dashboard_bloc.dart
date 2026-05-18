import 'package:flutter_bloc/flutter_bloc.dart';

import '../all_api_calls/all_api_calls.dart';
import '../events/dashboard_events.dart';
import '../states/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AllApiCalls _apiCalls;

  DashboardBloc(this._apiCalls) : super(DashboardState()) {
    on<GetDashboard>(_onGetDashboard);
  }

  Future<void> _onGetDashboard(
    GetDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final dashboard = await _apiCalls.getDashboard();
      emit(state.copyWith(isLoading: false, dashboardData: dashboard));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
