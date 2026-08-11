import 'package:crv_reprosisa/features/ocr/domain/entities/processed_image.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/report_type.dart';

class ImageProcessingState {
  final bool isProcessing;
  final ProcessedImage? processedImage;
  final String? errorMessage;
  final ReportType? reportType;

  const ImageProcessingState({
    this.isProcessing = false,
    this.processedImage,
    this.errorMessage,
    this.reportType,
  });

  ImageProcessingState copyWith({
    bool? isProcessing,
    ProcessedImage? processedImage,
    String? errorMessage,
    ReportType? reportType,
  }) {
    return ImageProcessingState(
      isProcessing: isProcessing ?? this.isProcessing,
      processedImage: processedImage ?? this.processedImage,
      errorMessage: errorMessage,
      reportType: reportType ?? this.reportType,
    );
  }
}
