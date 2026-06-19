import '../../domain/entities/banda_template.dart';
import '../../domain/entities/client_mine.dart';
import '../../domain/entities/roller.dart'; // Asegúrate de importar tu entidad

class BandaInspectionState {
  final bool isLoading;
  final List<Client> clients;
  final List<Mine> allMines;
  final List<Mine> filteredMines;
  final List<BandaSection> sections;
  final List<Roller> rollers; // 🔹 Nueva lista para rodillería

  final Client? selectedClient;
  final Mine? selectedMine;
  final DateTime inspectionDate;
  final String elaboro;
  final String area;
  final String seccion;

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
    this.rollers = const [], // 🔹 Inicialización vacía
    this.selectedClient,
    this.selectedMine,
    required this.inspectionDate,
    this.elaboro = '',
    this.area = '',
    this.seccion = '',
    this.conveyor = '',
    this.conveyorResponsible = '',
    this.recommendedBelt = '',
    this.material = '',
    this.granulometry = '',
    this.presentTo = '',
    this.generalComments = '',
  });

  factory BandaInspectionState.initial() {
    return BandaInspectionState(
      isLoading: false,
      clients: const [],
      allMines: const [],
      filteredMines: const [],
      sections: const [],
     rollers: List.generate(8, (index) => Roller(
        tableNumber: index + 1, // Puedes asignar el número de mesa automáticamente
        baseNumber: 0,
        isLeft: false,
        isCenter: false,
        isRight: false,
        isImpact: false,
        isReturn: false,
        isTriple: false,
        isSelfAligning: false,
        rollerType: '',
      )), // 🔹 Inicializamos con 8 filas vacías
      selectedClient: null,
      selectedMine: null,
      inspectionDate: DateTime.now(),
      elaboro: '',
      area: '',
      seccion: '', 
      conveyor: '',
      conveyorResponsible: '',
      recommendedBelt: '',
      material: '',
      granulometry: '',
      presentTo: '',
      generalComments: '',
    );
  }

  BandaInspectionState copyWith({
    bool? isLoading,
    List<Client>? clients,
    List<Mine>? allMines,
    List<Mine>? filteredMines,
    List<BandaSection>? sections,
    List<Roller>? rollers, // 🔹 Añadido al copyWith
    Client? selectedClient,
    bool clearMine = false,
    Mine? selectedMine,
    DateTime? inspectionDate,
    String? elaboro,
    String? area,
    String? seccion, 
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
      rollers: rollers ?? this.rollers, // 🔹 Asignación
      selectedClient: selectedClient ?? this.selectedClient,
      selectedMine: clearMine ? null : (selectedMine ?? this.selectedMine),
      inspectionDate: inspectionDate ?? this.inspectionDate,
      elaboro: elaboro ?? this.elaboro,
      area: area ?? this.area,
      seccion: seccion ?? this.seccion, 
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