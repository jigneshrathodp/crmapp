import 'package:equatable/equatable.dart';

// Sentinel – differentiates "not passed" from explicitly-null in copyWith.
const _sentinel = Object();

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
    Object? error = _sentinel,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profileDetails: profileDetails ?? this.profileDetails,
      error: identical(error, _sentinel) ? this.error : error as String?,
    );
  }

  @override
  List<Object?> get props => [isLoading, profileDetails, error];
}
