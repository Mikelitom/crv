import '../../domain/entities/entities_press.dart';
import '../../domain/entities/loan_area.dart';
import '../../domain/entities/component_item.dart';

class InspeccionState {
  final String? editingVersionId;
  final Press? selectedPress;
  final DateTime inspectionDate;
  final String area;

  final String? solicitantsName;
  final String? observations;

  final String state;
  final String status;

  final List<LoanArea> loanAreas;
  final LoanArea? selectedLoanArea;

  final List<ComponentItem> allTemplateItems;
  final List<ComponentItem> templateItems;

  final bool isLoading;

  const InspeccionState({
    this.editingVersionId,
    this.selectedPress,
    required this.inspectionDate,
    this.area = '',
    this.loanAreas = const [],
    this.selectedLoanArea,
    this.solicitantsName,
    this.observations,
    this.state = "IN_PROGRESS",
    this.status = '',
    this.isLoading = false,
    this.allTemplateItems = const [],
    this.templateItems = const [],
  });

  bool get isEditing => editingVersionId != null;

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
    bool clearSolicitantsName = false,
  
    String? observations,
    bool clearObservations = false,
  
    String? state,
    String? status,
    bool? isLoading,
  
    List<ComponentItem>? allTemplateItems,
    List<ComponentItem>? templateItems,
  }) {
    return InspeccionState(
      editingVersionId: clearEditingVersion
          ? null
          : (editingVersionId ?? this.editingVersionId),
  
      selectedPress: clearPress
          ? null
          : (selectedPress ?? this.selectedPress),
  
      inspectionDate: inspectionDate ?? this.inspectionDate,
      area: area ?? this.area,
  
      loanAreas: loanAreas ?? this.loanAreas,
  
      selectedLoanArea: clearLoanArea
          ? null
          : (selectedLoanArea ?? this.selectedLoanArea),
  
      solicitantsName: clearSolicitantsName
          ? null
          : (solicitantsName ?? this.solicitantsName),
  
      observations: clearObservations
          ? null
          : (observations ?? this.observations),
  
      state: state ?? this.state,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
  
      allTemplateItems: allTemplateItems ?? this.allTemplateItems,
      templateItems: templateItems ?? this.templateItems,
    );
  }
}
