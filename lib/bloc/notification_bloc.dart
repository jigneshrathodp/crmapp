import 'package:flutter_bloc/flutter_bloc.dart';

import '../all_api_calls/all_api_calls.dart';
import '../events/notification_events.dart';
import '../states/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final AllApiCalls _apiCalls;

  NotificationBloc(this._apiCalls) : super(NotificationState()) {
    on<GetUnreadNotifications>(_onGetUnreadNotifications);
    on<GetReadNotifications>(_onGetReadNotifications);
    on<MarkNotificationRead>(_onMarkNotificationRead);
    on<MarkAllNotificationsRead>(_onMarkAllNotificationsRead);
    on<DeleteNotification>(_onDeleteNotification);
  }

  Future<void> _onGetUnreadNotifications(
    GetUnreadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final response = await _apiCalls.getUnreadNotifications();
      emit(
        state.copyWith(isLoading: false, unreadNotifications: response['data']),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onGetReadNotifications(
    GetReadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final response = await _apiCalls.getReadNotifications();
      emit(
        state.copyWith(isLoading: false, readNotifications: response['data']),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onMarkNotificationRead(
    MarkNotificationRead event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _apiCalls.markNotificationRead(event.id);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onMarkAllNotificationsRead(
    MarkAllNotificationsRead event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _apiCalls.markAllNotificationsRead();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _apiCalls.deleteNotification(event.id);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
