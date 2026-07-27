import 'package:crv_reprosisa/features/ocr/domain/usecase/process_image_usecase.dart';
import 'package:crv_reprosisa/features/ocr/presentation/state/image_processing_state.dart';
import 'package:flutter_riverpod/legacy.dart';

class ImageProcessingNotifier 
    extends StateNotifier<ImageProcessingState> {


  final ProcessImageUseCase processImageUseCase;


  ImageProcessingNotifier(
    this.processImageUseCase,
  ) : super(
    const ImageProcessingState(),
  );


  Future<void> processImage(
    String imagePath,
  ) async {
  
    if (state.isProcessing) {
      return;
    }
  
    try {
  
      state = state.copyWith(
        isProcessing: true,
        errorMessage: null,
        processedImage: null,
      );
  
  
      final result =
          await processImageUseCase(imagePath);
  
  
      state = state.copyWith(
        isProcessing: false,
        processedImage: result,
      );
  
  
    } catch(e) {
  
      state = state.copyWith(
        isProcessing: false,
        errorMessage: e.toString(),
      );
  
    }
  }


  void clear() {

    state = const ImageProcessingState();

  }

}