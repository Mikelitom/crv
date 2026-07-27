import 'package:crv_reprosisa/features/ocr/domain/entities/processed_image.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class DocumentContour {
  final int index;
  final cv.VecPoint contour;

  DocumentContour({required this.index, required this.contour});
}

class OpenCVDataSource {
  Future<ProcessedImage> processImage(String imagePath) async {
    final image = cv.imread(imagePath);

    final gray = _toGray(image);

    final blur = _blur(gray);

    final edges = _canny(blur);

    final threshold = _adaptiveThreshold(gray);

    final closed = _morphClose(edges);

    final contour = _drawDocumentContour(image, closed);

    return _saveResults(
      imagePath: imagePath,
      gray: gray,
      blur: blur,
      edges: edges,
      contour: contour,
      threshold: threshold,
      closed: closed
    );
  }

  cv.Mat _toGray(cv.Mat image) {
    return cv.cvtColor(image, cv.COLOR_BGR2GRAY);
  }

  cv.Mat _blur(cv.Mat image) {
    return cv.gaussianBlur(image, (5, 5), 0);
  }

  cv.Mat _canny(cv.Mat image) {
    return cv.canny(image, 50, 150);
  }

  cv.Mat _adaptiveThreshold(cv.Mat image) {
    return cv.adaptiveThreshold(
      image,
      255,
      cv.ADAPTIVE_THRESH_GAUSSIAN_C,
      cv.THRESH_BINARY,
      21,
      10,
    );
  }

  cv.Mat _drawDocumentContour(cv.Mat original, cv.Mat edges) {
    final output = original.clone();

    final result = cv.findContours(
      edges,
      cv.RETR_EXTERNAL,
      cv.CHAIN_APPROX_SIMPLE,
    );

    final contours = result.$1;

    final document = _findLargestQuadrilateral(contours);

    if (document == null) {
      print("No se encontró documento");
      return output;
    }

    print("Documento encontrado");

    cv.drawContours(
      output,
      contours,
      document.index,
      cv.Scalar(0, 255, 0),
      thickness: 4,
    );

    return output;
  }

  DocumentContour? _findLargestQuadrilateral(cv.Contours contours) {
    double maxArea = 0;
    int? bestIndex;

    for (int i = 0; i < contours.length; i++) {
      final contour = contours[i];

      final area = cv.contourArea(contour);

      if (area < 1000) {
        continue;
      }

      final perimeter = cv.arcLength(contour, true);

      final approx = cv.approxPolyDP(contour, 0.02 * perimeter, true);

      print(
        "Contour $i area: $area puntos: ${approx.length}",
      );

      if (approx.length == 4 && area > maxArea) {
        maxArea = area;
        bestIndex = i;
      }

      if (approx.length == 4) {
      
        print(
          "CUADRILATERO $i area $area puntos:"
        );
      
        for (int j = 0; j < approx.length; j++) {
          print(approx[j]);
        }
      
      }
    }

    if (bestIndex == null) {
      return null;
    }

    return DocumentContour(index: bestIndex, contour: contours[bestIndex]);
  }

  cv.Mat _morphClose(cv.Mat image) {
    final kernel = cv.getStructuringElement(cv.MORPH_RECT, (5, 5));

    return cv.morphologyEx(image, cv.MORPH_CLOSE, kernel);
  }

  ProcessedImage _saveResults({
    required String imagePath,
    required cv.Mat gray,
    required cv.Mat blur,
    required cv.Mat edges,
    required cv.Mat contour,
    required cv.Mat threshold,
    required cv.Mat closed,
  }) {
    final grayPath = _generatePath(imagePath, "gray");

    final blurPath = _generatePath(imagePath, "blur");

    final edgesPath = _generatePath(imagePath, "edges");

    final contourPath = _generatePath(imagePath, "contour");

    final thresholdPath = _generatePath(imagePath, "threshold");

    final closedPath = _generatePath(imagePath, "closed");

    cv.imwrite(grayPath, gray);
    cv.imwrite(blurPath, blur);
    cv.imwrite(edgesPath, edges);
    cv.imwrite(contourPath, contour);
    cv.imwrite(thresholdPath, threshold);
    cv.imwrite(closedPath, closed);

    return ProcessedImage(
      originalPath: imagePath,
      grayPath: grayPath,
      blurPath: blurPath,
      cannyPath: edgesPath,
      contourPath: contourPath,
      thresholdPath: thresholdPath,
      closedPath: closedPath,
      perspectivePath: null,
    );
  }

  String _generatePath(String originalPath, String suffix) {
    final index = originalPath.lastIndexOf(".");

    if (index == -1) {
      return "${originalPath}_$suffix";
    }

    final name = originalPath.substring(0, index);

    final extension = originalPath.substring(index);

    return "${name}_$suffix$extension";
  }
}
