import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../provider/banda_inspection_providers.dart';
import '../provider/banda_inspection_state.dart';
import '../../domain/entities/client_mine.dart';
import '../../domain/entities/banda_template.dart';
import '../../../../core/error/failure.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_notifier_provider.dart';

class BandaInspectionNotifier extends Notifier<BandaInspectionState> {
  @override
  BandaInspectionState build() => BandaInspectionState.initial();

  void reset() {
    final authState = ref.read(authNotifierProvider);
    final userName = authState.user?.name ?? "Usuario";
    
    state = BandaInspectionState.initial().copyWith(
      elaboro: userName,
      inspectionDate: DateTime.now(),
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

      final sections = (results[0] as Either<Failure, List<BandaSection>>).fold((l) => <BandaSection>[], (r) => r);
      final clients = (results[1] as Either<Failure, List<Client>>).fold((l) => <Client>[], (r) => r);
      final mines = (results[2] as Either<Failure, List<Mine>>).fold((l) => <Mine>[], (r) => r);

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

  // 🔹 NUEVO MÉTODO: Autocompletado de reporte guardado
  void loadExistingReport(Map<String, dynamic> reportData) {
    // 1. Cargar datos generales
    state = state.copyWith(
      conveyor: reportData['conveyor'] ?? "",
      area: reportData['area'] ?? "",
      conveyorResponsible: reportData['conveyor_responsible'] ?? "",
      recommendedBelt: reportData['recommended_belt'] ?? "",
      material: reportData['material'] ?? "",
      granulometry: reportData['granulometry'] ?? "",
      presentTo: reportData['present_to'] ?? "",
    );

    // 2. Hidratar secciones y componentes
    final List<dynamic> answers = reportData['answers'] ?? [];
    
    final updatedSections = state.sections.map((section) {
      final updatedComponents = section.components.map((comp) {
        // Buscamos si existe una respuesta guardada para este accesorio
        final answer = answers.firstWhere(
          (a) => a['accesory_id'] == comp.id,
          orElse: () => null,
        );

        if (answer != null) {
          return comp.copyWith(
            selectedOptionId: answer['option_id'],
            observation: answer['recommended_action'] ?? "",
            dimension: answer['dimentions']?.toString() ?? "",
          );
        }
        return comp;
      }).toList();

      return section.copyWith(components: updatedComponents);
    }).toList();

    state = state.copyWith(sections: updatedSections);
  }

  // --- LÓGICA DE CLIENTE Y MINA ---
  void selectClient(Client client) {
    final filtered = state.allMines.where((m) => m.clientId == client.id).toList();
    state = state.copyWith(
      selectedClient: client,
      filteredMines: filtered,
      selectedMine: null,
    );
  }

  void selectMine(Mine mine) => state = state.copyWith(selectedMine: mine);

  // --- MÉTODOS DE ACTUALIZACIÓN ---
  void updateElaboro(String val) => state = state.copyWith(elaboro: val);
  void updateArea(String val) => state = state.copyWith(area: val);
  void updateSeccion(String val) => state = state.copyWith(seccion: val);
  void updateConveyor(String val) => state = state.copyWith(conveyor: val);
  void updateConveyorResponsible(String val) => state = state.copyWith(conveyorResponsible: val);
  void updateRecommendedBelt(String val) => state = state.copyWith(recommendedBelt: val);
  void updateMaterial(String val) => state = state.copyWith(material: val);
  void updateGranulometry(String val) => state = state.copyWith(granulometry: val);
  void updatePresentTo(String val) => state = state.copyWith(presentTo: val);
  void updateGeneralComments(String val) => state = state.copyWith(generalComments: val);

  void updateMaterialAndGranulometry(String val) {
    final parts = val.split('/');
    final material = parts.isNotEmpty ? parts[0].trim() : '';
    final granulometry = parts.length > 1 ? parts[1].trim() : '';
    state = state.copyWith(material: material, granulometry: granulometry);
  }

  void updateComponentOption(String sectionId, String componentId, String optionId) {
    _updateComponent(sectionId, componentId, (comp) => comp.copyWith(selectedOptionId: optionId));
  }

  void updateComponentDimension(String sectionId, String componentId, String dim) {
    _updateComponent(sectionId, componentId, (comp) => comp.copyWith(dimension: dim));
  }

  void updateComponentObservation(String sectionId, String componentId, String obs) {
    _updateComponent(sectionId, componentId, (comp) => comp.copyWith(observation: obs));
  }

  void addEvidence(String sectionId, String componentId, EvidenceFile file, bool isBefore) {
    _updateComponent(sectionId, componentId, (comp) => comp.copyWith(
      evidenceBefore: isBefore ? [file] : comp.evidenceBefore,
      evidenceAfter: isBefore ? comp.evidenceAfter : [file],
    ));
  }

  void removeEvidence(String sectionId, String componentId, bool isBefore) {
    _updateComponent(sectionId, componentId, (comp) => comp.copyWith(
      evidenceBefore: isBefore ? [] : comp.evidenceBefore,
      evidenceAfter: isBefore ? comp.evidenceAfter : [],
    ));
  }

  void _updateComponent(String sId, String cId, BandaComponent Function(BandaComponent) transform) {
    state = state.copyWith(
      sections: state.sections.map((section) {
        if (section.id == sId) {
          return section.copyWith(
            components: section.components.map((comp) => comp.id == cId ? transform(comp) : comp).toList(),
          );
        }
        return section;
      }).toList(),
    );
  }
}