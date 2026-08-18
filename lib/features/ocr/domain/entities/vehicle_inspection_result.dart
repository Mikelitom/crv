import 'package:crv_reprosisa/features/ocr/domain/entities/vehicle_checkbox_analysis.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/vehicle_inspection_row.dart';

class VehicleInspectionResult {
  final VehicleInspectionRow row;
  final VehicleCheckboxAnalysis analysis;

  const VehicleInspectionResult({required this.row, required this.analysis});

  String get selectedOption => analysis.highestOption;

  double get confidence => analysis.highestValue;
}
