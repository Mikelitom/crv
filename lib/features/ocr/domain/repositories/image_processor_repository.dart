import 'package:crv_reprosisa/features/ocr/domain/entities/processed_image.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/report_type.dart';

abstract class ImageProcessorRepository {

  Future<ProcessedImage> processImage(
    String imagePath,
    ReportType reportType
  );

}