import 'package:crv_reprosisa/features/ocr/domain/entities/processed_image.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class OpenCVDataSource {

  Future<ProcessedImage> processImage(String imagePath) async {

    // Leer imagen
    final image = cv.imread(imagePath);

    // Escala de grises
    final gray = cv.cvtColor(
      image,
      cv.COLOR_BGR2GRAY,
    );

    // Reducir ruido
    final blur = cv.gaussianBlur(
      gray,
      (5, 5),
      0,
    );

    // Adaptive Threshold
    final threshold = cv.adaptiveThreshold(
      blur,
      255,
      cv.ADAPTIVE_THRESH_GAUSSIAN_C,
      cv.THRESH_BINARY,
      21,
      10,
    );

    // Rutas
    final grayPath = _generatePath(imagePath, "gray");
    final blurPath = _generatePath(imagePath, "blur");
    final thresholdPath = _generatePath(imagePath, "threshold");

    // Guardar imágenes
    cv.imwrite(grayPath, gray);
    cv.imwrite(blurPath, blur);
    cv.imwrite(thresholdPath, threshold);

    // Regresar entidad
    return ProcessedImage(
      originalPath: imagePath,
      grayPath: grayPath,
      blurPath: blurPath,
      thresholdPath: thresholdPath,
      cannyPath: null,
      contourPath: null,
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