// IMPORTANTE: Importa la entidad, NO el modelo
import '../../domain/entities/press_report_detail_entity.dart';

class PressReportDetailState {
  final bool isLoading;
  final PressReportDetailEntity? data; // Cambiado de Model a Entity
  final String? error;

  const PressReportDetailState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  factory PressReportDetailState.initial() => const PressReportDetailState();

  PressReportDetailState copyWith({
    bool? isLoading,
    PressReportDetailEntity? data, // Cambiado de Model a Entity
    String? error,
  }) {
    return PressReportDetailState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
    );
  }
}