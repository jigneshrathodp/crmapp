import 'package:equatable/equatable.dart';

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileDetails extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final Map<String, dynamic> data;

  const UpdateProfile(this.data);

  @override
  List<Object?> get props => [data];
}

class ResetPassword extends ProfileEvent {
  final Map<String, dynamic> data;

  const ResetPassword(this.data);

  @override
  List<Object?> get props => [data];
}

// Bloc
