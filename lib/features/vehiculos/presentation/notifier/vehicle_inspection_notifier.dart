import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../provider/vehicle_inspection_provider.dart';
import '../provider/vehicle_inspection_state.dart';
import '../../data/models/component_vehicle_model.dart';
import '../../../../features/evidence/presentation/providers/evidence_service_provider.dart';

class VehicleInspectionNotifier extends Notifier<VehicleInspectionState> {
  @override
  VehicleInspectionState build() {
    Future.microtask(() {
      loadTemplate();
      loadVehicles();
    });
    return VehicleInspectionState(inspectionDate: DateTime.now());
  }
void updateReportState(String newState) {
    state = state.copyWith(state: newState);
  }
  Future<void> loadVehicles() async {
    final useCase = ref.read(getActiveVehiclesUseCaseProvider);
    final result = await useCase();

    result.fold(
      (f) {
        print("Error loading vehicles");
      },
      (vehicles) {
        print("Loaded vehicles: ${vehicles.length}");
        state = state.copyWith(activeVehicles: vehicles);
      },
    );
  }

  void updateMileage(String v) => state = state.copyWith(mileage: v);
  void toggleService(bool v) => state = state.copyWith(requiresService: v);
  void setScanning(bool value) => state = state.copyWith(isScanning: value);
  void updateServiceObservations(String v) =>
      state = state.copyWith(serviceObservations: v);
void setGeneralNotes(String v) => state = state.copyWith(generalNotes: v);
  // --- AUTOCOMPLETADO AL SELECCIONAR PLACA ---
  void onPlateSelected(String plate) {
    try {
      print("Active vehicles: ${state.activeVehicles.length}");
      final vehicle = state.activeVehicles.firstWhere(
        (v) => v.plate.trim().toUpperCase() == plate.trim().toUpperCase(),
      );
      print(vehicle.toString());
      state = state.copyWith(selectedVehicle: vehicle);
    } catch (_) {
      state = state.copyWith(clearVehicle: true);
    }
  }

  Future<void> loadTemplate() async {
    state = state.copyWith(isLoading: true);
    final useCase = ref.read(getVehicleTemplateUseCaseProvider);
    final result = await useCase();
    result.fold((f) => state = state.copyWith(isLoading: false), (data) {
      final List<ComponentVehicleModel> components = [];
      for (var sec in data['sections']) {
        for (var c in sec['components']) {
          components.add(
            ComponentVehicleModel(id: c['id'], description: c['name']),
          );
        }
      }
      state = state.copyWith(
        templateSections: data['sections'],
        templateOptions: data['options'],
        items: components,
        isLoading: false,
      );
    });
  }

  Future<String?> finalizarInspeccion() async {
    if (state.selectedVehicle == null) return null;
    state = state.copyWith(isLoading: true);
    final evidenceService = ref.read(evidenceServiceProvider);
    final List<Map<String, dynamic>> answers = [];

    try {
      for (var item in state.items.where((i) => i.selectedOptionId != null)) {
        final List<Map<String, String>> uploadedEvidences = [];
        
        final allEvidences = [...item.evidenceBefore, ...item.evidenceAfter];

        for (var ev in allEvidences) {
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/v_${DateTime.now().microsecondsSinceEpoch}.jpg');
          await file.writeAsBytes(ev.bytes);

          final uploadResult = await evidenceService.uploadEvidence(file: file, basePath: 'inspecciones/vehiculos');
          uploadResult.fold((f) => null, (dto) => uploadedEvidences.add({
            "file_path": dto.filePath,
            "file_type": dto.fileType,
            "mime_type": dto.mimeType,
            "file_size": dto.fileSize.toString(),
          }));
        }

        answers.add({
          "component_id": item.id,
          "option_id": item.selectedOptionId, // Según tu cURL
          "observation": item.observations,
          "evidences": uploadedEvidences,
        });
      }

      final reportRequest = {
        "vehicle_id": state.selectedVehicle!.id,
        "state": state.state, 
        "inspection_date": DateTime.now().toIso8601String(),
        "location": "Hermosillo",
        "mileage": int.tryParse(state.mileage) ?? 0,
        "requires_service": state.requiresService,
        "observation": state.serviceObservations,
        "folio": "V-${DateTime.now().millisecondsSinceEpoch}",
        "general_notes": state.generalNotes,
        "answers": answers,
      };

      final result = await ref.read(createVehicleReportUseCaseProvider).call(reportRequest);
      return result.fold((f) => null, (id) => id);
    } catch (e) { return null; }
    finally { state = state.copyWith(isLoading: false); }
  }

  void reset() {
    state = VehicleInspectionState(
      inspectionDate: DateTime.now(),
      activeVehicles: state.activeVehicles,
      templateSections: state.templateSections,
      templateOptions: state.templateOptions,
    );
  }
}
