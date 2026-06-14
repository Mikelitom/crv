import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/core/models/inspection_models.dart';
import '../provider/inspection_providers.dart';
import '../provider/inspection_state.dart';
import '../models/inspector_row_ui.dart';
import 'package:crv_reprosisa/features/inspections/data/models/vehicle_report_detail_model.dart';

class InspectionNotifier extends Notifier<InspectionState> {
  @override
  InspectionState build() => InspectionState();

  Future<void> loadInspections() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(getMyInspectionsUseCaseProvider).call();
    result.fold(
      (f) => state = state.copyWith(isLoading: false, errorMessage: "Error"),
      (data) => state = state.copyWith(
        isLoading: false, 
        allInspections: data, 
        filteredInspections: data,
        stats: _calculateStats(data)
      ),
    );
  }

  Future<void> loadInspectionDetail(String id) async {
    state = state.copyWith(isDetailLoading: true, errorMessage: null);
    final result = await ref.read(getInspectionByIdUseCaseProvider).call(id);
    result.fold(
      (f) => state = state.copyWith(isDetailLoading: false, errorMessage: "Error"),
      (inspection) => state = state.copyWith(
        isDetailLoading: false, 
        selectedInspection: inspection,
        vehicleHistory: state.vehicleHistory, 
      ),
    );
  }

  Future<void> loadVehicleHistory(String vehicleId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(getVehicleHistoryUseCaseProvider).call(vehicleId);
    result.fold(
      (f) => state = state.copyWith(isLoading: false, errorMessage: "Error historial"),
      (history) => state = state.copyWith(isLoading: false, vehicleHistory: history),
    );
  }

  void filterInspections(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredInspections: state.allInspections);
    } else {
      final filtered = state.allInspections.where((item) => 
        item.title.toLowerCase().contains(query.toLowerCase())
      ).toList();
      state = state.copyWith(filteredInspections: filtered);
    }
  }

  List<StatsModel> _calculateStats(List<InspectionRowUI> data) {
    int total = data.length;
    int completadas = 0;
    int enProceso = 0;

    for (var item in data) {
      final stateUpper = item.state.toUpperCase();
      if (stateUpper.contains('COMPLET') || stateUpper.contains('FINALIZADO')) {
        completadas++;
      } else {
        enProceso++;
      }
    }

    return [
      StatsModel(value: total.toString(), label: "Totales", color: Colors.black),
      StatsModel(value: enProceso.toString(), label: "En Proceso", color: Colors.orange),
      StatsModel(value: completadas.toString(), label: "Completados", color: Colors.green),
    ];
  }

  /// Recupera el detalle del reporte usando el UseCase correspondiente
  Future<VehicleReportDetailModel?> getReportDetail(String id) async {
    state = state.copyWith(isDetailLoading: true);
    try {
      // Usamos el UseCase registrado en inspection_providers.dart
      final result = await ref.read(getVehicleReportDetailUseCaseProvider).call(id);
      
      state = state.copyWith(isDetailLoading: false);
      
      return result.fold(
        (failure) {
          debugPrint("Error al cargar detalle: ${failure.toString()}");
          return null;
        },
        (model) => model, // Retorna correctamente el modelo
      );
    } catch (e) {
      state = state.copyWith(isDetailLoading: false);
      debugPrint("Excepción inesperada: $e");
      return null;
    }
  }
}