import 'package:crv_reprosisa/core/models/inspection_models.dart';
import '../../domain/entities/inspection.dart'; 
import '../models/inspector_row_ui.dart';

class InspectionState {
  final bool isLoading;
  final List<InspectionRowUI> allInspections;
  final List<InspectionRowUI> filteredInspections;
  final List<StatsModel> stats; 
  final String? errorMessage;
    final bool isDetailLoading;
  final Inspection? selectedInspection; 

  InspectionState({
    this.isLoading = false,
    this.allInspections = const [],
    this.filteredInspections = const [],
    this.stats = const [], 
    this.errorMessage,
    this.isDetailLoading = false,
    this.selectedInspection,
  });

  InspectionState copyWith({
    bool? isLoading,
    List<InspectionRowUI>? allInspections,
    List<InspectionRowUI>? filteredInspections,
    List<StatsModel>? stats,
    String? errorMessage,
    bool? isDetailLoading,
    Inspection? selectedInspection, 
  }) {
    return InspectionState(
      isLoading: isLoading ?? this.isLoading,
      allInspections: allInspections ?? this.allInspections,
      filteredInspections: filteredInspections ?? this.filteredInspections,
      stats: stats ?? this.stats,
      errorMessage: errorMessage,
      isDetailLoading: isDetailLoading ?? this.isDetailLoading,
      selectedInspection: selectedInspection ?? this.selectedInspection,
    );
  }
}