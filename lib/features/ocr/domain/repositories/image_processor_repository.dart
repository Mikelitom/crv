import 'package:crv_reprosisa/features/ocr/domain/entities/processed_image.dart';

abstract class ImageProcessorRepository {

  Future<ProcessedImage> processImage(
    String imagePath,
  );

}