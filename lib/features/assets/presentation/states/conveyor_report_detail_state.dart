// lib/features/assets/presentation/states/conveyor_report_detail_state.dart
import '../../domain/entities/conveyor_report_detail.dart';

class ConveyorReportDetailState {
  final bool isLoading;
  final ConveyorReportDetail? data;
  final String? error;

  const ConveyorReportDetailState({
    required this.isLoading,
    this.data,
    this.error,
  });

  // Constructor inicial para cuando la app carga
  factory ConveyorReportDetailState.initial() => const ConveyorReportDetailState(
        isLoading: false,
      );

  // Método para crear una copia del estado con cambios
  ConveyorReportDetailState copyWith({
    bool? isLoading,
    ConveyorReportDetail? data,
    String? error,
  }) {
    return ConveyorReportDetailState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
    );
  }
}