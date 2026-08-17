import 'package:crv_reprosisa/features/ocr/domain/entities/ocr_processing_result.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/report_type.dart';

abstract class ImageProcessorRepository {

  Future<OcrProcessingResult> processImage(
    String imagePath,
    ReportType reportType
  );

}