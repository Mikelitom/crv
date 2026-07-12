import '../../domain/entities/banda_template.dart';
import '../../domain/entities/client_mine.dart';
import '../../domain/entities/roller.dart';

class BandaInspectionState {
  final bool isLoading;
  final String? editingReportId; 
  final String? editingVersionId;
  final List<Client> clients;
  final List<Mine> allMines;
  final List<Mine> filteredMines;
  final List<BandaSection> sections;
  final List<Roller> rollers; 

  final bool isRodilleriaActive; 
  final String reportStatus;    
  final String rollerNotes;

  final Client? selectedClient;
  final Mine? selectedMine;
  final DateTime inspectionDate;
  final String elaboro;
  final String area;
  final String seccion;

  final String conveyor;
  final String conveyorResponsible;
  final String recommendedBelt;
  final String material;
  final String granulometry;
  final String presentTo;
  final String generalComments;

  const BandaInspectionState({
    this.isLoading = false,
    this.editingReportId,    
    this.editingVersionId,   
    this.clients = const [],
    this.allMines = const [],
    this.filteredMines = const [],
    this.sections = const [],
    this.rollers = const [],
    this.isRodilleriaActive = false,
    this.reportStatus = 'IN_PROGRESS',
    this.rollerNotes = '',
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

  bool get isEditing => editingReportId != null;

  factory BandaInspectionState.initial() {
    return BandaInspectionState(
      inspectionDate: DateTime.now(),
      rollers: List.generate(8, (index) => Roller(
        tableNumber: index + 1,
        baseNumber: 0,
        isLeft: false,
        isCenter: false,
        isRight: false,
        isImpact: false,
        isReturn: false,
        isTriple: false,
        isSelfAligning: false,
        observation: '', 
      )),
    );
  }

  BandaInspectionState copyWith({
    bool? isLoading,
    String? editingReportId,
    bool clearEditingReport = false,
    String? editingVersionId,
    bool clearEditingVersion = false,
    List<Client>? clients,
    List<Mine>? allMines,
    List<Mine>? filteredMines,
    List<BandaSection>? sections,
    List<Roller>? rollers,
    bool? isRodilleriaActive,
    String? rollerNotes,
    String? reportStatus,
    Client? selectedClient,
    bool clearClient = false,
    Mine? selectedMine,
    bool clearMine = false,
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
      editingReportId: clearEditingReport ? null : (editingReportId ?? this.editingReportId),
      editingVersionId: clearEditingVersion ? null : (editingVersionId ?? this.editingVersionId),
      clients: clients ?? this.clients,
      allMines: allMines ?? this.allMines,
      filteredMines: filteredMines ?? this.filteredMines,
      sections: sections ?? this.sections,
      rollers: rollers ?? this.rollers,
      isRodilleriaActive: isRodilleriaActive ?? this.isRodilleriaActive,
      reportStatus: reportStatus ?? this.reportStatus,
      rollerNotes: rollerNotes ?? this.rollerNotes,
      selectedClient: clearClient ? null : (selectedClient ?? this.selectedClient),
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