import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/core/utils/imege_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../provider/banda_inspection_providers.dart';
import 'package:collection/collection.dart';
import '../provider/banda_inspection_state.dart';
import '../../domain/entities/client_mine.dart';
import '../../domain/entities/banda_template.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/roller.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_notifier_provider.dart';

class BandaInspectionNotifier extends Notifier<BandaInspectionState> {
  String? _editingReportId;
  bool get isEditing => _editingReportId != null;
  String? get editingReportId => _editingReportId;

  void setEditingReportId(String id) => _editingReportId = id;
  @override
  BandaInspectionState build() => BandaInspectionState.initial();

  void reset() {
    final authState = ref.read(authNotifierProvider);
    final userName = authState.user?.name ?? "Usuario";
    _editingReportId = null;

    state = BandaInspectionState.initial().copyWith(
      elaboro: userName,
      inspectionDate: DateTime.now(),
    );
  }

  void toggleRodilleria(bool active) {
    state = state.copyWith(
      isRodilleriaActive: active,
      rollers: active ? [] : [],
    );
  }

  void removeRoller(int index) {
    final currentRollers = List<Roller>.from(state.rollers);
    if (index >= 0 && index < currentRollers.length) {
      currentRollers.removeAt(index);
      state = state.copyWith(rollers: currentRollers);
    }
  }

  // Agrega esto a tu
  void addRoller() {
    final newRoller = Roller(
      tableNumber:
          state.rollers.length + 1, // Sugerencia: autoincrementar número
      baseNumber: 0,
      isLeft: false,
      isCenter: false,
      isRight: false,
      isImpact: false,
      isReturn: false,
      isTriple: false,
      isSelfAligning: false,
      observation: '',
    );
    state = state.copyWith(rollers: [...state.rollers, newRoller]);
  }

  void setReportStatus(String status) {
    state = state.copyWith(reportStatus: status);
  }

  void updateComponentComment(
    String sectionId,
    String componentId,
    String comment,
  ) {
    _updateComponent(
      sectionId,
      componentId,
      (comp) => comp.copyWith(comment: comment),
    );
  }

  Future<void> initialLoad() async {
    reset();
    state = state.copyWith(isLoading: true);
    try {
      final results = await Future.wait([
        ref.read(getBandaTemplateUseCaseProvider).call(),
        ref.read(getActiveClientsUseCaseProvider).call(),
        ref.read(getActiveMinesUseCaseProvider).call(),
      ]);

      final sections = (results[0] as Either<Failure, List<BandaSection>>).fold(
        (l) => <BandaSection>[],
        (r) => r,
      );
      final clients = (results[1] as Either<Failure, List<Client>>).fold(
        (l) => <Client>[],
        (r) => r,
      );
      final mines = (results[2] as Either<Failure, List<Mine>>).fold(
        (l) => <Mine>[],
        (r) => r,
      );

      state = state.copyWith(
        sections: sections,
        clients: clients,
        allMines: mines,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadExistingReport(Map<String, dynamic> reportData) async {
    state = state.copyWith(isLoading: true);

    try {
      // 1. Extraer los objetos raíz según el nuevo JSON
      final Map<String, dynamic> report = reportData['report'] ?? {};
      final Map<String, dynamic> conveyorInfo = reportData['conveyor'] ?? {};
      final List<dynamic> answers = reportData['answers'] ?? [];

      // Autocompletado de Mina/Cliente (usando el nombre que viene en el JSON)
      final String mineName = conveyorInfo['mine']?.toString() ?? "";
      final foundMine = state.allMines.firstWhereOrNull(
        (m) => m.name.toLowerCase() == mineName.toLowerCase(),
      );
      final foundClient = foundMine != null
          ? state.clients.firstWhereOrNull((c) => c.id == foundMine.clientId)
          : null;

      // 2. Mapeo de Secciones
      final updatedSections = await Future.wait(
        state.sections.map((section) async {
          final updatedComponents = await Future.wait(
            section.components.map((comp) async {
              // 🔥 CLAVE: Buscar todas las respuestas asociadas a este accesorio (puede haber varias opciones marcadas)
              final componentAnswers = answers
                  .where(
                    (a) =>
                        a['accesory']?['id']?.toString() == comp.id.toString(),
                  )
                  .toList();

              if (componentAnswers.isNotEmpty) {
                // Extraer todos los IDs de opciones y custom_options
                List<String> selectedIds = [];
                String obs = "";
                String dim = "";
                String com = "";

                for (var ans in componentAnswers) {
                  // Opción fija
                  if (ans['option'] != null) {
                    selectedIds.add(ans['option']['id'].toString());
                  }
                  // Opción personalizada
                  if (ans['custom_option'] != null) {
                    selectedIds.add(ans['custom_option'].toString());
                  }
                  // Tomar valores de los campos (si existen)
                  obs = ans['recommended_action']?.toString() ?? obs;
                  dim = ans['dimentions']?.toString() ?? dim;
                  com = ans['comment']?.toString() ?? com;
                }

                return comp.copyWith(
                  selectedOptionIds: selectedIds,
                  observation: obs,
                  dimentions: dim,
                  comment: com,
                );
              }
              return comp;
            }),
          );
          return section.copyWith(components: updatedComponents);
        }),
      );

      // 3. Mapeo de rodillos (está correcto en tu estructura original)
      List<Roller> loadedRollers = [];
      final List<dynamic> rollersData = reportData['rollers'] ?? [];
      loadedRollers = rollersData
          .map(
            (r) => Roller(
              id: r['id'],
              tableNumber: r['table_number'] ?? 0,
              baseNumber: r['base_number'] ?? 0,
              isLeft: r['is_left'] ?? false,
              isCenter: r['is_center'] ?? false,
              isRight: r['is_right'] ?? false,
              isImpact: r['is_impact'] ?? false,
              isReturn: r['is_return'] ?? false,
              isTriple: r['is_triple'] ?? false,
              isSelfAligning: r['is_self_aligning'] ?? false,
              observation: r['observation']?.toString() ?? '',
            ),
          )
          .toList();

      // 4. Actualizar estado
      state = state.copyWith(
        isLoading: false,
        sections: updatedSections,
        rollers: loadedRollers,
        selectedMine: foundMine,
        selectedClient: foundClient,
        conveyor: conveyorInfo['name']?.toString() ?? "",
        area: conveyorInfo['area']?.toString() ?? "",
        conveyorResponsible: report['conveyor_responsible']?.toString() ?? "",
        recommendedBelt: report['recommended_belt']?.toString() ?? "",
        material: report['material']?.toString() ?? "",
        granulometry: report['granulometry']?.toString() ?? "",
        presentTo: report['present_to']?.toString() ?? "",
        rollerNotes: report['roller_notes']?.toString() ?? "",
      );
    } catch (e) {
      debugPrint("Error crítico al cargar reporte: $e");
      state = state.copyWith(isLoading: false);
    }
  }

  void updateRoller(
    int index, {
    int? tableNumber,
    int? baseNumber,
    bool? isLeft,
    bool? isCenter,
    bool? isRight,
    bool? isImpact,
    bool? isReturn,
    String? supportType,
    String? observation,
  }) {
    final updatedRollers = List<Roller>.from(state.rollers);
    final old = updatedRollers[index];

    updatedRollers[index] = Roller(
      tableNumber: tableNumber ?? old.tableNumber,
      baseNumber: baseNumber ?? old.baseNumber,
      isLeft: isLeft ?? old.isLeft,
      isCenter: isCenter ?? old.isCenter,
      isRight: isRight ?? old.isRight,
      isImpact: isImpact ?? old.isImpact,
      isReturn: isReturn ?? old.isReturn,
      isTriple:
          supportType ==
          "Triple", // O guarda el string directamente si tu entidad lo permite
      isSelfAligning: supportType == "Auto",
      observation: observation ?? old.observation,
    );

    state = state.copyWith(rollers: updatedRollers);
  }

  // --- MÉTODOS DE ACTUALIZACIÓN DE ESTADO ---
  void selectClient(Client client) {
    final filtered = state.allMines
        .where((m) => m.clientId == client.id)
        .toList();
    state = state.copyWith(
      selectedClient: client,
      filteredMines: filtered,
      selectedMine: null,
    );
  }

  void selectMine(Mine mine) => state = state.copyWith(selectedMine: mine);
  void updateElaboro(String val) => state = state.copyWith(elaboro: val);
  void updateArea(String val) => state = state.copyWith(area: val);
  void updateSeccion(String val) => state = state.copyWith(seccion: val);
  void updateConveyor(String val) => state = state.copyWith(conveyor: val);
  void updateConveyorResponsible(String val) =>
      state = state.copyWith(conveyorResponsible: val);
  void updateRecommendedBelt(String val) =>
      state = state.copyWith(recommendedBelt: val);
  void updateMaterial(String val) => state = state.copyWith(material: val);
  void updateGranulometry(String val) =>
      state = state.copyWith(granulometry: val);
  void updatePresentTo(String val) => state = state.copyWith(presentTo: val);
  void updateGeneralComments(String val) =>
      state = state.copyWith(generalComments: val);

  // LOGICA PARA OPCIONES PERSONALIZADAS
  void addCustomOption(String sectionId, String componentId, String label) {
    _updateComponent(sectionId, componentId, (comp) {
      final newCustom = List<String>.from(comp.customOptions);
      if (!newCustom.contains(label)) newCustom.add(label);
      return comp.copyWith(customOptions: newCustom);
    });
  }

  void toggleComponentOption(
    String sectionId,
    String componentId,
    String optionId,
  ) {
    _updateComponent(sectionId, componentId, (comp) {
      final newSelections = List<String>.from(comp.selectedOptionIds);
      if (newSelections.contains(optionId)) {
        newSelections.remove(optionId);
      } else {
        newSelections.add(optionId);
      }
      return comp.copyWith(selectedOptionIds: newSelections);
    });
  }

  void updateComponentDimension(
    String sectionId,
    String componentId,
    String dim,
  ) {
    _updateComponent(
      sectionId,
      componentId,
      (comp) => comp.copyWith(dimentions: dim),
    );
  }

  void updateComponentObservation(
    String sectionId,
    String componentId,
    String obs,
  ) {
    _updateComponent(
      sectionId,
      componentId,
      (comp) => comp.copyWith(observation: obs),
    );
  }

  void addEvidence(
    String sectionId,
    String componentId,
    EvidenceFile file,
    bool isBefore,
  ) {
    _updateComponent(
      sectionId,
      componentId,
      (comp) => comp.copyWith(
        evidenceBefore: isBefore
            ? [...comp.evidenceBefore, file]
            : comp.evidenceBefore,
        evidenceAfter: isBefore
            ? comp.evidenceAfter
            : [...comp.evidenceAfter, file],
      ),
    );
  }

  void removeEvidence(
    String sectionId,
    String componentId,
    bool isBefore,
    int index,
  ) {
    _updateComponent(sectionId, componentId, (comp) {
      final newBefore = List<EvidenceFile>.from(comp.evidenceBefore);
      final newAfter = List<EvidenceFile>.from(comp.evidenceAfter);
      if (isBefore) {
        if (index >= 0 && index < newBefore.length) newBefore.removeAt(index);
      } else {
        if (index >= 0 && index < newAfter.length) newAfter.removeAt(index);
      }
      return comp.copyWith(evidenceBefore: newBefore, evidenceAfter: newAfter);
    });
  }

  void removeCustomOption(String sectionId, String componentId, String label) {
    _updateComponent(sectionId, componentId, (comp) {
      final newCustom = List<String>.from(comp.customOptions)..remove(label);
      final newSelections = List<String>.from(comp.selectedOptionIds)
        ..remove(label);
      return comp.copyWith(
        customOptions: newCustom,
        selectedOptionIds: newSelections,
      );
    });
  }

  void updateRollerNotes(String notes) {
    state = state.copyWith(rollerNotes: notes);
  }

  void _updateComponent(
    String sId,
    String cId,
    BandaComponent Function(BandaComponent) transform,
  ) {
    state = state.copyWith(
      sections: state.sections.map((section) {
        if (section.id == sId) {
          return section.copyWith(
            components: section.components
                .map((comp) => comp.id == cId ? transform(comp) : comp)
                .toList(),
          );
        }
        return section;
      }).toList(),
    );
  }
}
