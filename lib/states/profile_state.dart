import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final Map<String, dynamic>? profileDetails;
  final String? error;

  const ProfileState({
    this.isLoading = false,
    this.profileDetails,
    this.error,
  });

  ProfileState copyWith({
    bool? isLoading,
    Map<String, dynamic>? profileDetails,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profileDetails: profileDetails ?? this.profileDetails,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, profileDetails, error];
}
