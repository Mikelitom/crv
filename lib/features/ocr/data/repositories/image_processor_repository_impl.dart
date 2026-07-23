import '../../domain/entities/processed_image.dart';
import '../../domain/repositories/image_processor_repository.dart';
import '../datasources/opencv_datasource.dart';


class ImageProcessorRepositoryImpl 
    implements ImageProcessorRepository {


  final OpenCVDataSource datasource;


  ImageProcessorRepositoryImpl(this.datasource);


  @override
  Future<ProcessedImage> processImage(String imagePath) async {

    final processed =
        await datasource.processImage(imagePath);


    return ProcessedImage(
      originalPath: imagePath,
      processedPath: processed,
    );
  }
}