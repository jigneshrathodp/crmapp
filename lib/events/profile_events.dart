import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileDetails extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final Map<String, String> fields;
  final Map<String, http.MultipartFile>? imageFiles;

  const UpdateProfile(this.fields, {this.imageFiles});

  @override
  List<Object?> get props => [fields];
}

class ResetPassword extends ProfileEvent {
  final Map<String, dynamic> data;

  const ResetPassword(this.data);

  @override
  List<Object?> get props => [data];
}

// Bloc
