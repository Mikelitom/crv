import 'package:crv_reprosisa/features/ocr/domain/entities/press_inspection_result.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/processed_image.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/vehicle_inspection_result.dart';

class OcrProcessingResult {
  final ProcessedImage processedImage;
  final PressInspectionResult? pressInspection;
  final List<VehicleInspectionResult>? vehicleInspection;

  const OcrProcessingResult({
    required this.processedImage,
    this.pressInspection,
    this.vehicleInspection,
  });
}
