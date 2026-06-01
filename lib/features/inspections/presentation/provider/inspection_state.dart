import 'package:crv_reprosisa/core/models/inspection_models.dart';
import '../../domain/entities/inspection.dart';
import '../../domain/entities/vehicle_inspection.dart';
import '../models/inspector_row_ui.dart';

class InspectionState {
  final bool isLoading;
  final bool isDetailLoading;
  final List<InspectionRowUI> allInspections;
  final List<InspectionRowUI> filteredInspections;
  final List<StatsModel> stats;
  final String? errorMessage;
  final Inspection? selectedInspection;
  final List<VehicleInspection> vehicleHistory;

  InspectionState({
    this.isLoading = false,
    this.isDetailLoading = false,
    this.allInspections = const [],
    this.filteredInspections = const [],
    this.stats = const [],
    this.errorMessage,
    this.selectedInspection,
    this.vehicleHistory = const [],
  });

  InspectionState copyWith({
    bool? isLoading,
    bool? isDetailLoading,
    List<InspectionRowUI>? allInspections,
    List<InspectionRowUI>? filteredInspections,
    List<StatsModel>? stats,
    String? errorMessage,
    Inspection? selectedInspection,
    List<VehicleInspection>? vehicleHistory,
  }) {
    return InspectionState(
      isLoading: isLoading ?? this.isLoading,
      isDetailLoading: isDetailLoading ?? this.isDetailLoading,
      allInspections: allInspections ?? this.allInspections,
      filteredInspections: filteredInspections ?? this.filteredInspections,
      stats: stats ?? this.stats,
      errorMessage: errorMessage,
      selectedInspection: selectedInspection ?? this.selectedInspection,
      vehicleHistory: vehicleHistory ?? this.vehicleHistory ?? const [],
    );
  }
}