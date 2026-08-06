import 'package:crv_reprosisa/features/ocr/domain/entities/processed_image.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/report_type.dart';
import 'package:crv_reprosisa/features/ocr/domain/repositories/image_processor_repository.dart';

class ProcessImageUseCase {
  final ImageProcessorRepository repository;

  ProcessImageUseCase(this.repository);

  Future<ProcessedImage> call(String imagePath, ReportType reportType) {
    return repository.processImage(imagePath, reportType);
  }
}