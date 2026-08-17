import 'package:crv_reprosisa/features/ocr/domain/entities/press_inspection_result.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/processed_image.dart';

class OcrProcessingResult {
  final ProcessedImage processedImage;
  final PressInspectionResult? pressInspection;

  const OcrProcessingResult({
    required this.processedImage,
    this.pressInspection,
  });
}
