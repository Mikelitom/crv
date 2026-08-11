import 'package:crv_reprosisa/features/ocr/domain/entities/report_type.dart';
import 'package:crv_reprosisa/features/ocr/domain/usecase/process_image_usecase.dart';
import 'package:crv_reprosisa/features/ocr/presentation/state/image_processing_state.dart';
import 'package:flutter_riverpod/legacy.dart';

class ImageProcessingNotifier extends StateNotifier<ImageProcessingState> {
  final ProcessImageUseCase processImageUseCase;

  ImageProcessingNotifier(this.processImageUseCase)
    : super(const ImageProcessingState());

  Future<void> processImage(String imagePath, ReportType reportType) async {
    if (state.isProcessing) {
      return;
    }

    try {
      state = state.copyWith(
        isProcessing: true,
        errorMessage: null,
        processedImage: null,
        reportType: reportType,
      );

      final result = await processImageUseCase(imagePath, reportType);

      state = state.copyWith(isProcessing: false, processedImage: result);
    } catch (e) {
      state = state.copyWith(isProcessing: false, errorMessage: e.toString());
    }
  }

  Future<void> reprocess() async {
    final image = state.processedImage;
    final reportType = state.reportType;

    if (image == null || reportType == null) {
      return;
    }

    await processImage(image.originalPath, reportType);
  }

  void clear() {
    state = const ImageProcessingState();
  }
}
