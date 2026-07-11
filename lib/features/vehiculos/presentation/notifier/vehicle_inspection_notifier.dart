import 'dart:io';
import 'package:collection/collection.dart'; // NECESARIO para firstWhereOrNull
import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/core/utils/imege_downloader.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_report_detail.dart';
import 'package:crv_reprosisa/features/inspections/presentation/provider/inspection_providers.dart'
    hide getVehicleReportDetailUseCaseProvider;
import 'package:flutter/rendering.dart';
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
    state = state.copyWith(reportState: newState);
  }
  Future<void> loadReportDetail(String versionId) async {
    reset();
    state = state.copyWith(
      editingVersionId: versionId,
      isLoading: true,
    );

    if (state.templateSections.isEmpty) {
      await loadTemplate();
    }

    if (state.activeVehicles.isEmpty) {
      await loadVehicles();
    }

    final useCase = ref.read(getVehicleReportDetailUseCaseProvider);
    final result = await useCase.call(versionId);

    result.fold((failure) => state = state.copyWith(isLoading: false), (
      data,
    ) async {
      // Hacemos async para descargar imágenes
      final List<ComponentVehicleModel> updatedItems = [];

      for (var item in state.items) {
        final answer = data.answers.firstWhereOrNull(
          (a) =>
              a.componentName.toString().trim().toLowerCase() ==
              item.description.trim().toLowerCase(),
        );

        if (answer != null) {
          final option = state.templateOptions.firstWhere(
            (o) =>
                o['name'].toString().trim().toLowerCase() ==
                answer.optionName.toString().trim().toLowerCase(),
            orElse: () => {'id': null},
          );

          // DESCARGA DE IMÁGENES
          List<EvidenceFile> evidences = [];
          if (answer.evidencePaths != null) {
            for (var path in answer.evidencePaths!) {
              // Asumimos que tienes una utilidad de descarga
              final bytes = await ImageDownloader.download(
                ref.read(dioProvider),
                path,
              );
              if (bytes != null) {
                evidences.add(
                  EvidenceFile(
                    bytes: bytes,
                    type: 'image/jpeg',
                    mimeType: 'image/jpeg',
                  ),
                );
              }
            }
          }

          updatedItems.add(
            item.copyWith(
              selectedOptionId: option['id']?.toString(),
              observations: answer.observation?.toString() ?? "",
              evidenceBefore: evidences,
            ),
          );
        } else {
          updatedItems.add(item);
        }
      }

      final vehicle = state.activeVehicles.firstWhereOrNull(
        (v) => v.id == data.vehicle.vehicleId,
      );

      final report = data.report;

      state = state.copyWith(
        editingVersionId: report["report_id"],
        isLoading: false,
        selectedVehicle: vehicle,
        mileage: (report["mileage"] ?? "").toString(),
        requiresService: report["requires_service"] ?? false,
        reportState: report["state"] ?? "IN_PROGRESS",
        generalNotes: report["general_notes"] ?? "",
        serviceObservations: report["observation"] ?? "",
        items: updatedItems,
      );
    });
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
        final List<Map<String, dynamic>> uploadedEvidences = [];
        final allEvidences = [...item.evidenceBefore, ...item.evidenceAfter];

        for (var ev in allEvidences) {
          // CASO A: Imagen ya existente (la reutilizamos enviando su path)
          if (ev.path != null && ev.path!.isNotEmpty) {
            uploadedEvidences.add({
              "file_path": ev.path!,
              "file_type": ev.type,
              "mime_type": ev.mimeType,
              "file_size": "0",
            });
          }
          // CASO B: Imagen nueva (la subimos al servidor)
          else if (ev.bytes.isNotEmpty) {
            final tempDir = await getTemporaryDirectory();
            final file = File(
              '${tempDir.path}/v_${DateTime.now().microsecondsSinceEpoch}.jpg',
            );
            await file.writeAsBytes(ev.bytes);

            final uploadResult = await evidenceService.uploadEvidence(
              file: file,
              basePath: 'inspecciones/vehiculos',
            );
            uploadResult.fold(
              (f) => null,
              (dto) => uploadedEvidences.add({
                "file_path": dto.filePath,
                "file_type": dto.fileType,
                "mime_type": dto.mimeType,
                "file_size": dto.fileSize.toString(),
              }),
            );
          }
        }

        answers.add({
          "component_id": item.id,
          "option_id": item.selectedOptionId,
          "observation": item.observations,
          "evidences": uploadedEvidences,
        });
      }

      final reportRequest = {
        "vehicle_id": state.selectedVehicle!.id,
        "state": state.reportState,
        "inspection_date": DateTime.now().toIso8601String(),
        "location": "Hermosillo",
        "mileage": int.tryParse(state.mileage) ?? 0,
        "requires_service": state.requiresService,
        "observation": state.serviceObservations,
        "folio": "V-${DateTime.now().millisecondsSinceEpoch}",
        "general_notes": state.generalNotes,
        "answers": answers,
      };

      debugPrint("editingReportId = ${state.editingVersionId}");

      if (state.isEditing) {
        debugPrint("UPDATE");

        final updateUseCase = ref.read(updateVehicleReportUseCaseProvider);

        final result = await updateUseCase.call(
          state.editingVersionId!,
          reportRequest,
        );

        final id = result.fold((f) => null, (id) => id);
        
        if (id != null) {
          reset();
        }
        
        return id;
      }

      debugPrint("CREATE");

      final createUseCase = ref.read(createVehicleReportUseCaseProvider);

      final result = await createUseCase.call(reportRequest);

      final id = result.fold((f) => null, (id) => id);
      
      if (id != null) {
        reset();
      }
      
      return id;
    } catch (e) {
      debugPrint("Error al finalizar: $e");
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
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
