import 'package:crv_reprosisa/features/ocr/domain/entities/processed_image.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/press_inspection_result.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/report_type.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/vehicle_inspection_result.dart';

class ImageProcessingState {
  final bool isProcessing;
  final ProcessedImage? processedImage;
  final PressInspectionResult? pressInspection;
  final List<VehicleInspectionResult> vehicleInspection;
  final String? errorMessage;
  final ReportType? reportType;

  const ImageProcessingState({
    this.isProcessing = false,
    this.processedImage,
    this.pressInspection,
    this.vehicleInspection = const [],
    this.errorMessage,
    this.reportType,
  });

  ImageProcessingState copyWith({
    bool? isProcessing,
    ProcessedImage? processedImage,
    PressInspectionResult? pressInspection,
    List<VehicleInspectionResult>? vehicleInspection,
    String? errorMessage,
    ReportType? reportType,
  }) {
    return ImageProcessingState(
      isProcessing: isProcessing ?? this.isProcessing,
      processedImage: processedImage ?? this.processedImage,
      pressInspection: pressInspection ?? this.pressInspection,
      vehicleInspection: vehicleInspection ?? this.vehicleInspection,
      errorMessage: errorMessage,
      reportType: reportType ?? this.reportType,
    );
  }
}