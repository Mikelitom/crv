import 'package:opencv_dart/opencv_dart.dart' as cv;

class OpenCVDataSource {

  Future<String> processImage(String imagePath) async {

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
      (5,5),
      0,
    );

    // Blanco y negro
    final threshold = cv.threshold(
      blur,
      120,
      255,
      cv.THRESH_BINARY,
    );

    final outputPath = imagePath.replaceFirst(
      ".jpg",
      "_processed.jpg",
    );

    cv.imwrite(
      outputPath,
      threshold.$2,
    );

    return outputPath;
  }
}