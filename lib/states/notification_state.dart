import 'package:equatable/equatable.dart';

class NotificationState extends Equatable {
  final bool isLoading;
  final List<dynamic>? unreadNotifications;
  final List<dynamic>? readNotifications;
  final String? error;

  const NotificationState({
    this.isLoading = false,
    this.unreadNotifications,
    this.readNotifications,
    this.error,
  });

  NotificationState copyWith({
    bool? isLoading,
    List<dynamic>? unreadNotifications,
    List<dynamic>? readNotifications,
    String? error,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      readNotifications: readNotifications ?? this.readNotifications,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        unreadNotifications,
        readNotifications,
        error,
      ];
}
