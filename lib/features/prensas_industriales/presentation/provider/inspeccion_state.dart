import '../../domain/entities/entities_press.dart';

class InspeccionState {
  final Press? selectedPress;
  final DateTime inspectionDate;
  final String area;
  final bool isLoading;

  InspeccionState({
    this.selectedPress, 
    required this.inspectionDate, 
    this.area = '', 
    this.isLoading = false
  });

  InspeccionState copyWith({
    Press? selectedPress, 
    bool clearPress = false, 
    DateTime? inspectionDate, 
    String? area, 
    bool? isLoading
  }) {
    return InspeccionState(
      selectedPress: clearPress ? null : (selectedPress ?? this.selectedPress),
      inspectionDate: inspectionDate ?? this.inspectionDate,
      area: area ?? this.area,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}