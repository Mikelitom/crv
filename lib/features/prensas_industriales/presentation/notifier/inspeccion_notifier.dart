import 'dart:io';

import 'package:collection/collection.dart'; // NECESARIO para firstWhereOrNull
import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/core/utils/imege_downloader.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_report_detail_provider.dart';
import 'package:crv_reprosisa/features/evidence/presentation/providers/evidence_service_provider.dart';
import 'package:crv_reprosisa/features/prensas_industriales/data/models/component_model.dart';
import 'package:crv_reprosisa/features/prensas_industriales/data/models/press_model.dart';
import 'package:crv_reprosisa/features/prensas_industriales/domain/entities/component_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../provider/inspeccion_state.dart';
import '../provider/inspeccion_providers.dart';
import '../../domain/entities/loan_area.dart';

class InspeccionNotifier extends Notifier<InspeccionState> {
  String? _editingReportId;
  bool get isEditing => _editingReportId != null;
  @override
  InspeccionState build() {
    Future.microtask(() => loadLoanAreas());
    return InspeccionState(inspectionDate: DateTime.now());
  }

  void updateState(String status) {
    state = state.copyWith(state: status);
  }

  void updateTemplateItems(List<ComponentItem> items) =>
      state = state.copyWith(templateItems: items);

  Future<void> loadReportDetail(String versionId) async {
    // 1. Reset seguro que mantiene templates si existen
    final currentTemplates = state.templateItems;

    state = state.copyWith(isLoading: true, editingVersionId: versionId);

    try {
      // Asegurar template
      if (currentTemplates.isEmpty) {
        final repo = ref.read(inspeccionRepositoryProvider);
        final result = await repo.getInspectionTemplate();
        result.fold(
          (f) => null,
          (items) => state = state.copyWith(templateItems: items),
        );
      }

      await ref.read(pressReportDetailProvider.notifier).fetchDetail(versionId);
      final detailState = ref.read(pressReportDetailProvider);

      if (detailState.data != null) {
        final data = detailState.data!;

        _editingReportId = data.report["report_id"];

        final List<PrensaComponentItem> updatedItems = [];

        for (var item in state.templateItems.cast<PrensaComponentItem>()) {
          final answer = data.answers.firstWhereOrNull(
            (a) =>
                a.componentName.toString().trim().toLowerCase() ==
                item.name.toString().trim().toLowerCase(),
          );

          if (answer != null) {
            List<EvidenceFile> evidences = [];

            for (var path in answer.evidencePaths) {
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
                    path: path,
                  ),
                );
              }
            }

            updatedItems.add(
              item.copyWith(
                status: answer.status.toUpperCase(),
                observation: answer.observation,
                quantity: answer.quantity,
                evidenceBefore: evidences,
              ),
            );
          } else {
            updatedItems.add(item);
          }
        }

        state = state.copyWith(
          isLoading: false,
          selectedPress: PressModel.fromJson(data.press),
          templateItems: updatedItems,
          area: data.report['area'] ?? "",
          solicitantsName: data.responsibleName,
          observations: data.report['observation'] ?? "",
          state: data.report['state'] ?? "IN_PROGRESS",
          selectedLoanArea: state.loanAreas.firstWhereOrNull(
            (a) => a.id == data.report['loan']?['area_id'],
          ),
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      debugPrint("Error crítico en loadReportDetail: $e");
      state = state.copyWith(isLoading: false);
    }
  }

  Future<String?> finalizarInspeccion() async {
    if (state.selectedPress == null) return null;
    state = state.copyWith(isLoading: true);
    final evidenceService = ref.read(evidenceServiceProvider);

    try {
      final List<Map<String, dynamic>> answers = [];
      for (var item in state.templateItems.cast<PrensaComponentItem>().where(
        (i) => i.status.isNotEmpty,
      )) {
        final List<Map<String, dynamic>> uploadedEvidences = [];
        for (var ev in [...item.evidenceBefore, ...item.evidenceAfter]) {
          String pathGuardar = ev.path ?? "";
          if (pathGuardar.contains('evidencias/'))
            pathGuardar = pathGuardar
                .split('evidencias/')
                .last
                .split('?')
                .first;

          if (pathGuardar.isNotEmpty) {
            uploadedEvidences.add({
              "file_path": pathGuardar,
              "file_type": ev.type,
              "mime_type": ev.mimeType,
              "file_size": "0",
            });
          }
          final tempDir = await getTemporaryDirectory();
          final file = File(
            '${tempDir.path}/p_${DateTime.now().microsecondsSinceEpoch}.jpg',
          );
          await file.writeAsBytes(ev.bytes);
          final uploadResult = await evidenceService.uploadEvidence(
            file: file,
            basePath: 'inspecciones/prensas',
          );
          uploadResult.fold(
            (f) => null,
            (dto) => uploadedEvidences.add({
              "file_path": dto.filePath,
              "file_type": dto.fileType,
              "mime_type": dto.mimeType,
              "file_size": "0",
            }),
          );
        }
        answers.add({
          "component_id": item.id,
          "quantity": item.quantity ?? 0,
          "status": item.status.toUpperCase(),
          "observation": item.observation.isEmpty ? null : item.observation,
          "evidences": uploadedEvidences,
        });
      }

      final Map<String, dynamic> reportRequest = {
        "press_id": state.selectedPress!.id,
        "inspection_date": DateTime.now().toIso8601String(),
        "state": state.state,
        "area": state.area.isEmpty ? "General" : state.area,
        "folio": "F-${DateTime.now().millisecondsSinceEpoch}",
        "answers": answers,
      };

      if (state.selectedLoanArea != null &&
          state.selectedLoanArea!.id.isNotEmpty) {
        reportRequest["loan"] = {
          "area_id": state.selectedLoanArea!.id,
          "loan_date": DateTime.now().toIso8601String(),
          "solicitants_name": state.solicitantsName ?? "N/A",
          "observations": state.observations ?? "Sin observaciones",
        };
      }

      final useCase = isEditing
          ? ref
                .read(updatePressReportProvider)
                .call(_editingReportId!, reportRequest)
          : ref.read(createPressReportProvider).call(reportRequest);
      return (await useCase).fold(
        (f) {
          debugPrint("Error: ${f.message}");
          return null;
        },
        (id) {
          reset();
          return id;
        },
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> onSerieSelected(String serie) async {
    state = state.copyWith(isLoading: true, status: '');

    // 1. Buscamos la prensa por serie
    final getPressUseCase = ref.read(getPressBySerieProvider);
    final result = await getPressUseCase(serie);

    await result.fold((f) async => state = state.copyWith(isLoading: false), (
      press,
    ) async {
      state = state.copyWith(selectedPress: press);

      // 2. LLAMADA AL USE CASE PARA OBTENER EL ÚLTIMO ESTADO (AHORA DEVUELVE MAP)
      final getStatusUseCase = ref.read(getLatestLoanStatusUseCaseProvider);
      final statusResult = await getStatusUseCase(press.id);

      statusResult.fold(
        (f) => state = state.copyWith(status: 'UNKNOWN', isLoading: false),
        (loanData) {
          // Extraemos el status para el badge visual
          final String currentStatus = loanData['status'] ?? 'AVAILABLE';

          // Lógica de autocompletado de área si la prensa está prestada (LOANED)
          LoanArea? autoSelectedArea;
          if (currentStatus == 'LOANED') {
            final String? areaId = loanData['area_id'];
            try {
              // Buscamos en la lista de áreas cargadas la que coincida con el ID
              autoSelectedArea = state.loanAreas.firstWhere(
                (a) => a.id == areaId,
              );
            } catch (_) {
              autoSelectedArea = null;
            }
          }

          state = state.copyWith(
            status: currentStatus,
            selectedLoanArea:
                autoSelectedArea, // Se asigna automáticamente si se encontró
            isLoading: false,
          );
        },
      );
    });
  }

  void updateSolicitantsName(String name) =>
      state = state.copyWith(solicitantsName: name);

  void updateObservations(String obs) =>
      state = state.copyWith(observations: obs);

  void updateArea(String area) => state = state.copyWith(area: area);

  void onSerieChanged(String serie) {
    if (serie.isEmpty) state = state.copyWith(clearPress: true, status: '');
  }

  Future<void> loadLoanAreas() async {
    final useCase = ref.read(getLoanAreasUseCaseProvider);
    final result = await useCase();
    result.fold(
      (f) => null,
      (areasList) => state = state.copyWith(loanAreas: areasList),
    );
  }

  void selectLoanArea(LoanArea? area) =>
      state = state.copyWith(selectedLoanArea: area);

  Future<void> createAndSelectLoanArea({
    required String name,
    String? phone,
    String? address,
  }) async {
    state = state.copyWith(isLoading: true);
    final useCase = ref.read(createLoanAreaUseCaseProvider);
    final result = await useCase({
      "name": name,
      "contact": phone ?? "N/A",
      "address": address ?? "N/A",
    });
    result.fold(
      (f) => state = state.copyWith(isLoading: false),
      (newArea) => state = state.copyWith(
        loanAreas: [...state.loanAreas, newArea],
        selectedLoanArea: newArea,
        isLoading: false,
      ),
    );
  }

  void reset() {
    final templates = state.templateItems;
    _editingReportId = null;
    state = InspeccionState(
      inspectionDate: DateTime.now(),
      loanAreas: state.loanAreas,
      templateItems: templates,
    );
  }
}
