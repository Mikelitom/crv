import '../../domain/entities/entities_press.dart';
import '../../domain/entities/loan_area.dart';

class InspeccionState {
  final Press? selectedPress;
  final DateTime inspectionDate;
  final String area;
  final List<LoanArea> loanAreas;
  final LoanArea? selectedLoanArea;
  final String solicitantsName;
  final String observations;
  final String state;
  final String status;
  final bool isLoading;

  InspeccionState({
    this.selectedPress,
    required this.inspectionDate,
    this.area = '',
    this.loanAreas = const [],
    this.selectedLoanArea,
    this.solicitantsName = '',
    this.observations = '',
    this.status = '',
    this.state = "IN_PROGRESS",
    this.isLoading = false,
  });

  InspeccionState copyWith({
    Press? selectedPress,
    bool clearPress = false,
    DateTime? inspectionDate,
    String? area,
    List<LoanArea>? loanAreas,
    LoanArea? selectedLoanArea,
    String? solicitantsName,
    String? observations,
    String? state,
    String? status,
    bool? isLoading,
  }) {
    return InspeccionState(
      selectedPress: clearPress ? null : (selectedPress ?? this.selectedPress),
      inspectionDate: inspectionDate ?? this.inspectionDate,
      area: area ?? this.area,
      loanAreas: loanAreas ?? this.loanAreas,
      selectedLoanArea: selectedLoanArea ?? this.selectedLoanArea,
      solicitantsName: solicitantsName ?? this.solicitantsName,
      observations: observations ?? this.observations,
      status: status ?? this.status,
      state: state ?? this.state,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
