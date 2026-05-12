import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart'; // Asegúrate de tener dartz importado
import '../provider/banda_inspection_providers.dart';
import '../provider/banda_inspection_state.dart';
import '../../domain/entities/client_mine.dart';
import '../../domain/entities/banda_template.dart';
import '../../../../core/error/failure.dart';


class BandaInspectionNotifier extends Notifier<BandaInspectionState> {
  @override
  BandaInspectionState build() => BandaInspectionState(inspectionDate: DateTime.now());

  Future<void> initialLoad() async {
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
        elaboro: "Juan Soto", 
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
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
  void updateElaboro(String val) => state = state.copyWith(elaboro: val);

  // --- ACTUALIZACIÓN DE COMPONENTES (EVITA ERROR DE FINAL) ---
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

  // Método privado para actualizar la jerarquía inmutable
  void _updateComponent(String sId, String cId, BandaComponent Function(BandaComponent) transform) {
    state = state.copyWith(
      sections: state.sections.map((section) {
        if (section.id == sId) {
          return BandaSection(
            id: section.id,
            name: section.name,
            components: section.components.map((comp) => comp.id == cId ? transform(comp) : comp).toList(),
          );
        }
        return section;
      }).toList(),
    );
  }
}