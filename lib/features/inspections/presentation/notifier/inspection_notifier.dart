import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/core/models/inspection_models.dart';
import '../provider/inspection_providers.dart';
import '../provider/inspection_state.dart';
import '../models/inspector_row_ui.dart';

class InspectionNotifier extends Notifier<InspectionState> {
  @override
  InspectionState build() => InspectionState();

  Future<void> loadInspections() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final result = await ref.read(getMyInspectionsUseCaseProvider).call();
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, errorMessage: "Error al cargar datos"),
      (inspections) {
        // Lógica para llenar los StatsModel basados en el estado de la API
        final stats = _calculateStats(inspections);

        state = state.copyWith(
          isLoading: false,
          allInspections: inspections,
          filteredInspections: inspections,
          stats: stats,
        );
      },
    );
  }

  List<StatsModel> _calculateStats(List<InspectionRowUI> data) {
    int total = data.length;
    
    int pendientes = data.where((item) => 
      item.state.toUpperCase().contains('PROGRESS') || 
      item.state.toUpperCase().contains('PENDIENTE')
    ).length;
    
    int completadas = data.where((item) => 
      item.state.toUpperCase().contains('COMPLET')
    ).length;
    
    return [
      StatsModel(value: total.toString(), label: "Totales", color: const Color(0xFF1A1C1E)),
      StatsModel(value: pendientes.toString(), label: "Pendientes", color: const Color(0xFFEF6C00)),
      StatsModel(value: completadas.toString(), label: "Completadas", color: const Color(0xFF2E7D32)),
    ];
  }

  void filterInspections(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredInspections: state.allInspections);
    } else {
      final filtered = state.allInspections.where((item) {
        final search = query.toLowerCase();
        return item.title.toLowerCase().contains(search) ||
               item.reportType.toLowerCase().contains(search) ||
               item.folio.toLowerCase().contains(search);
      }).toList();
      state = state.copyWith(filteredInspections: filtered);
    }
  }
  Future<void> loadInspectionDetail(String id) async {
  state = state.copyWith(isDetailLoading: true, errorMessage: null);
  
  final result = await ref.read(getInspectionByIdUseCaseProvider).call(id);
  
  result.fold(
    (failure) => state = state.copyWith(isDetailLoading: false, errorMessage: "Error al cargar detalle"),
    (inspection) => state = state.copyWith(
      isDetailLoading: false, 
      selectedInspection: inspection,
    ),
  );
}
}