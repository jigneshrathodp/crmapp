import 'package:equatable/equatable.dart';

const _sentinel = Object();

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
    Object? error = _sentinel,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      dashboardData: dashboardData ?? this.dashboardData,
      error: identical(error, _sentinel) ? this.error : error as String?,
    );
  }

  @override
  List<Object?> get props => [isLoading, dashboardData, error];
}
