// lib/features/assets/presentation/states/vehicle_report_detail_state.dart

import '../../data/models/vehicle_report_detail_model.dart';

class VehicleReportDetailState {
  final bool isLoading;
  final VehicleReportDetailModel? data;
  final String? error;

  const VehicleReportDetailState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  factory VehicleReportDetailState.initial() => const VehicleReportDetailState();

  VehicleReportDetailState copyWith({
    bool? isLoading,
    VehicleReportDetailModel? data,
    String? error,
  }) {
    return VehicleReportDetailState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
    );
  }
}