import '../../domain/entities/entities_press.dart';
import '../../domain/entities/loan_area.dart';

class InspeccionState {
  final Press? selectedPress;
  final DateTime inspectionDate;
  final String area; 
  final List<LoanArea> loanAreas; 
  final LoanArea? selectedLoanArea; 
  final bool isLoading;

  InspeccionState({
    this.selectedPress, 
    required this.inspectionDate, 
    this.area = '', 
    this.loanAreas = const [],
    this.selectedLoanArea,
    this.isLoading = false
  });

  InspeccionState copyWith({
    Press? selectedPress, 
    bool clearPress = false, 
    DateTime? inspectionDate, 
    String? area, 
    List<LoanArea>? loanAreas,
    LoanArea? selectedLoanArea,
    bool? isLoading
  }) {
    return InspeccionState(
      selectedPress: clearPress ? null : (selectedPress ?? this.selectedPress),
      inspectionDate: inspectionDate ?? this.inspectionDate,
      area: area ?? this.area,
      loanAreas: loanAreas ?? this.loanAreas,
      selectedLoanArea: selectedLoanArea ?? this.selectedLoanArea,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}