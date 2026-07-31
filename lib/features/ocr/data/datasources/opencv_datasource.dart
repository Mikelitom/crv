import 'package:crv_reprosisa/features/ocr/data/detectors/report_region_detector.dart';
import 'package:crv_reprosisa/features/ocr/data/preprocessors/document_preprocessor.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/processed_image.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class OpenCVDataSource {
  final ReportRegionDetector _documentDetector = const ReportRegionDetector();
  final DocumentPreprocessor _documentPreprocessor =
      const DocumentPreprocessor();

  Future<ProcessedImage> processImage(String imagePath) async {
    final image = cv.imread(imagePath);

    final processed = _documentPreprocessor.process(image);

    // Guardar temporalmente para inspección
    cv.imwrite(
      _generatePath(imagePath, "closed"),
      processed.closed,
    );

    final document = _documentDetector.detect(
      processed.closed,
      image,
    );

    final contour = _drawDocumentContour(
      image,
      document,
    );

    return _saveResults(
      imagePath: imagePath,
      gray: processed.gray,
      contour: contour,
      threshold: processed.threshold,
      closed: processed.closed,
    );
  }


  cv.Mat _drawDocumentContour(
    cv.Mat original,
    ReportRegion? document,
  ) {
    final output = original.clone();
  
    if (document == null) {
      print("No se encontró región del reporte");
      return output;
    }
  
    cv.drawContours(
      output,
      document.contours,
      document.index,
      cv.Scalar(0, 255, 0),
      thickness: 4,
    );
  
    return output;
  }


  ProcessedImage _saveResults({
    required String imagePath,
    required cv.Mat gray,
    required cv.Mat contour,
    required cv.Mat threshold,
    required cv.Mat closed,
  }) {

    final grayPath = _generatePath(
      imagePath,
      "gray",
    );

    final contourPath = _generatePath(
      imagePath,
      "contour",
    );

    final thresholdPath = _generatePath(
      imagePath,
      "threshold",
    );

    final closedPath = _generatePath(
      imagePath,
      "closed",
    );


    cv.imwrite(grayPath, gray);
    cv.imwrite(contourPath, contour);
    cv.imwrite(thresholdPath, threshold);
    cv.imwrite(closedPath, closed);


    return ProcessedImage(
      originalPath: imagePath,
      grayPath: grayPath,
      contourPath: contourPath,
      thresholdPath: thresholdPath,
      closedPath: closedPath,
      perspectivePath: null,
    );
  }


  String _generatePath(
    String originalPath,
    String suffix,
  ) {
    final index = originalPath.lastIndexOf(".");

    if (index == -1) {
      return "${originalPath}_$suffix";
    }

    final name = originalPath.substring(0, index);
    final extension = originalPath.substring(index);

    return "${name}_$suffix$extension";
  }
}