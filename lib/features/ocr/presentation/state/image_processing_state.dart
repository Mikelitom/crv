import '../../domain/entities/processed_image.dart';

class ImageProcessingState {

  final bool isProcessing;
  final ProcessedImage? processedImage;
  final String? errorMessage;


  const ImageProcessingState({
    this.isProcessing = false,
    this.processedImage,
    this.errorMessage,
  });


  ImageProcessingState copyWith({
    bool? isProcessing,
    ProcessedImage? processedImage,
    String? errorMessage,
  }) {
    return ImageProcessingState(
      isProcessing: isProcessing ?? this.isProcessing,
      processedImage: processedImage ?? this.processedImage,
      errorMessage: errorMessage,
    );
  }
}