import 'package:equatable/equatable.dart';

class DashboardState extends Equatable {
  final bool isLoading;
  final Map<String, dynamic>? dashboardData;
  final String? error;

  const DashboardState({
    this.isLoading = false,
    this.dashboardData,
    this.error,
  });

  DashboardState copyWith({
    bool? isLoading,
    Map<String, dynamic>? dashboardData,
    String? error,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      dashboardData: dashboardData ?? this.dashboardData,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        dashboardData,
        error,
      ];
}
