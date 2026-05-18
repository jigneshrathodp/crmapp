import 'package:flutter_bloc/flutter_bloc.dart';

import '../all_api_calls/all_api_calls.dart';
import '../events/advertise_events.dart';
import '../states/advertise_state.dart';

class AdvertiseBloc extends Bloc<AdvertiseEvent, AdvertiseState> {
  final AllApiCalls _apiCalls;

  AdvertiseBloc(this._apiCalls) : super(AdvertiseState()) {
    on<GetAdvertiseList>(_onGetAdvertiseList);
    on<CreateAdvertise>(_onCreateAdvertise);
    on<UpdateAdvertise>(_onUpdateAdvertise);
    on<DeleteAdvertise>(_onDeleteAdvertise);
  }

  Future<void> _onGetAdvertiseList(
    GetAdvertiseList event,
    Emitter<AdvertiseState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final advertises = await _apiCalls.getAdvertiseList();
      emit(state.copyWith(isLoading: false, advertiseList: advertises));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onCreateAdvertise(
    CreateAdvertise event,
    Emitter<AdvertiseState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final created = await _apiCalls.createAdvertise(event.data);
      emit(state.copyWith(isLoading: false, createdAdvertise: created));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateAdvertise(
    UpdateAdvertise event,
    Emitter<AdvertiseState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final updated = await _apiCalls.updateAdvertise(event.id, event.data);
      emit(state.copyWith(isLoading: false, updatedAdvertise: updated));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onDeleteAdvertise(
    DeleteAdvertise event,
    Emitter<AdvertiseState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final deleted = await _apiCalls.deleteAdvertise(event.id);
      emit(state.copyWith(isLoading: false, deletedAdvertise: deleted));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
