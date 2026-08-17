import 'package:crv_reprosisa/features/ocr/domain/entities/ocr_processing_result.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/report_type.dart';

import '../../domain/repositories/image_processor_repository.dart';
import '../datasources/opencv_datasource.dart';

class ImageProcessorRepositoryImpl
    implements ImageProcessorRepository {

  final OpenCVDataSource datasource;

  ImageProcessorRepositoryImpl(this.datasource);

  @override
  Future<OcrProcessingResult> processImage(String imagePath, ReportType reportType) {
    return datasource.processImage(imagePath, reportType: reportType);
  }
}