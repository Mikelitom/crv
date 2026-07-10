import '../../domain/entities/entities_press.dart';
import '../../domain/entities/loan_area.dart';
import '../../domain/entities/component_item.dart';

class InspeccionState {
  // =========================
  // Modo de la pantalla
  // =========================
  final String? editingVersionId;

  // =========================
  // Información del reporte
  // =========================
  final Press? selectedPress;
  final DateTime inspectionDate;
  final String area;
  final String solicitantsName;
  final String observations;
  final String state; // Estado del reporte (IN_PROGRESS, COMPLETED)
  final String status; // Status de la prensa (AVAILABLE, LOANED)

  // =========================
  // Préstamos
  // =========================
  final List<LoanArea> loanAreas;
  final LoanArea? selectedLoanArea;

  // =========================
  // Componentes inspeccionados
  // =========================
  final List<ComponentItem> templateItems;

  // =========================
  // UI
  // =========================
  final bool isLoading;

  const InspeccionState({
    this.editingVersionId,
    this.selectedPress,
    required this.inspectionDate,
    this.area = '',
    this.loanAreas = const [],
    this.selectedLoanArea,
    this.solicitantsName = '',
    this.observations = '',
    this.state = "IN_PROGRESS",
    this.status = '',
    this.isLoading = false,
    this.templateItems = const [],
  });

  /// Helper para saber si estamos editando
  bool get isEditing => editingVersionId != null;

  /// copyWith robusto con flags de limpieza
  InspeccionState copyWith({
    String? editingVersionId,
    bool clearEditingVersion = false,
    
    Press? selectedPress,
    bool clearPress = false,
    
    DateTime? inspectionDate,
    String? area,
    List<LoanArea>? loanAreas,
    LoanArea? selectedLoanArea,
    bool clearLoanArea = false,
    
    String? solicitantsName,
    String? observations,
    String? state,
    String? status,
    bool? isLoading,
    List<ComponentItem>? templateItems,
  }) {
    return InspeccionState(
      editingVersionId: clearEditingVersion ? null : (editingVersionId ?? this.editingVersionId),
      selectedPress: clearPress ? null : (selectedPress ?? this.selectedPress),
      inspectionDate: inspectionDate ?? this.inspectionDate,
      area: area ?? this.area,
      loanAreas: loanAreas ?? this.loanAreas,
      selectedLoanArea: clearLoanArea ? null : (selectedLoanArea ?? this.selectedLoanArea),
      solicitantsName: solicitantsName ?? this.solicitantsName,
      observations: observations ?? this.observations,
      state: state ?? this.state,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      templateItems: templateItems ?? this.templateItems,
    );
  }
}