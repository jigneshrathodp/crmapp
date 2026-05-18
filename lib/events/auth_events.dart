import 'package:equatable/equatable.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class Login extends AuthEvent {
  final Map<String, dynamic> data;

  const Login(this.data);

  @override
  List<Object?> get props => [data];
}

class Logout extends AuthEvent {}
