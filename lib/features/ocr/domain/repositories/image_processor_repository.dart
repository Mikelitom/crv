import '../entities/processed_document.dart';

abstract class ImageProcessorRepository {

  Future<ProcessedDocument> processImage(
    String imagePath,
  );

}