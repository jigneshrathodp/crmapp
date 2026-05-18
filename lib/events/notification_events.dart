import 'package:equatable/equatable.dart';

// Events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class GetUnreadNotifications extends NotificationEvent {}

class GetReadNotifications extends NotificationEvent {}

class MarkNotificationRead extends NotificationEvent {
  final int id;

  const MarkNotificationRead(this.id);

  @override
  List<Object?> get props => [id];
}

class MarkAllNotificationsRead extends NotificationEvent {}

class DeleteNotification extends NotificationEvent {
  final int id;

  const DeleteNotification(this.id);

  @override
  List<Object?> get props => [id];
}

// Bloc
