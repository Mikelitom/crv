import '../../domain/entities/banda_template.dart';
import '../../domain/entities/client_mine.dart';

class BandaInspectionState {
  final bool isLoading;
  final List<Client> clients;
  final List<Mine> allMines;
  final List<Mine> filteredMines;
  final List<BandaSection> sections;
  
  final Client? selectedClient;
  final Mine? selectedMine;
  final DateTime inspectionDate;
  final String elaboro;

  // Campos dinamicos para el formulario
  final String conveyor;
  final String conveyorResponsible;
  final String recommendedBelt;
  final String material;
  final String granulometry;
  final String presentTo;
  final String generalComments;

  BandaInspectionState({
    this.isLoading = false,
    this.clients = const [],
    this.allMines = const [],
    this.filteredMines = const [],
    this.sections = const [],
    this.selectedClient,
    this.selectedMine,
    required this.inspectionDate,
    this.elaboro = '',
    this.conveyor = '',
    this.conveyorResponsible = '',
    this.recommendedBelt = '',
    this.material = '',
    this.granulometry = '',
    this.presentTo = '',
    this.generalComments = '',
  });

  BandaInspectionState copyWith({
    bool? isLoading,
    List<Client>? clients,
    List<Mine>? allMines,
    List<Mine>? filteredMines,
    List<BandaSection>? sections,
    Client? selectedClient,
    bool clearMine = false,
    Mine? selectedMine,
    DateTime? inspectionDate,
    String? elaboro,
    String? conveyor,
    String? conveyorResponsible,
    String? recommendedBelt,
    String? material,
    String? granulometry,
    String? presentTo,
    String? generalComments,
  }) {
    return BandaInspectionState(
      isLoading: isLoading ?? this.isLoading,
      clients: clients ?? this.clients,
      allMines: allMines ?? this.allMines,
      filteredMines: filteredMines ?? this.filteredMines,
      sections: sections ?? this.sections,
      selectedClient: selectedClient ?? this.selectedClient,
      selectedMine: clearMine ? null : (selectedMine ?? this.selectedMine),
      inspectionDate: inspectionDate ?? this.inspectionDate,
      elaboro: elaboro ?? this.elaboro,
      conveyor: conveyor ?? this.conveyor,
      conveyorResponsible: conveyorResponsible ?? this.conveyorResponsible,
      recommendedBelt: recommendedBelt ?? this.recommendedBelt,
      material: material ?? this.material,
      granulometry: granulometry ?? this.granulometry,
      presentTo: presentTo ?? this.presentTo,
      generalComments: generalComments ?? this.generalComments,
    );
  }
}