import 'package:opencv_dart/opencv_dart.dart' as cv;

class DocumentContour {
  final int index;
  final cv.Contours contours;

  const DocumentContour({required this.index, required this.contours});
}

class DocumentDetector {
  const DocumentDetector();

  DocumentContour? detect(cv.Mat binaryImage, cv.Mat originalImage) {
    final result = cv.findContours(
      binaryImage,
      cv.RETR_EXTERNAL,
      cv.CHAIN_APPROX_SIMPLE,
    );

    final contours = result.$1;

    return _findBestContour(contours, originalImage);
  }

  DocumentContour? _findBestContour(cv.Contours contours, cv.Mat image) {
    double bestScore = -1;
    int? bestIndex;

    final imageArea = image.rows * image.cols;

    print("Total de contornos encontrados: ${contours.length}");

    for (int i = 0; i < contours.length; i++) {
      final contour = contours[i];

      final area = cv.contourArea(contour);

      final areaRatio = area / imageArea;

      print(
        "Contour $i areaRatio=${areaRatio.toStringAsFixed(3)}"
      );

      if (areaRatio < 0.02) {
        print(
          "Contour $i descartado por area: ${areaRatio.toStringAsFixed(3)}",
        );
        continue;
      }

      if (areaRatio > 0.98) {
        print(
          "Contour $i descartado por area: ${areaRatio.toStringAsFixed(3)}",
        );
        continue;
      }

      final perimeter = cv.arcLength(contour, true);

      final approx = cv.approxPolyDP(contour, 0.015 * perimeter, true);

      print(
        "Contour $i candidato | "
        "vertices=${approx.length} | "
        "area=${areaRatio.toStringAsFixed(3)}",
      );

      if (approx.length < 4 || approx.length > 12) {
        continue;
      }

      if (!cv.isContourConvex(approx)) {
        continue;
      }

      final rect = cv.boundingRect(approx);

      final marginX = rect.x / image.cols;
      final marginY = rect.y / image.rows;

      final rightMargin = (image.cols - (rect.x + rect.width)) / image.cols;

      final bottomMargin = (image.rows - (rect.y + rect.height)) / image.rows;

      final touchesBorder =
          marginX < 0.05 &&
          marginY < 0.05 &&
          rightMargin < 0.05 &&
          bottomMargin < 0.05;

      final widthRatio = rect.width / image.cols;
      final heightRatio = rect.height / image.rows;

      print(
        "Contour $i tamaño "
        "W:${widthRatio.toStringAsFixed(2)} "
        "H:${heightRatio.toStringAsFixed(2)}",
      );

      final rectArea = rect.width * rect.height;

      if (rectArea == 0) {
        continue;
      }

      final rectangularity = area / rectArea;

      if (rectangularity < 0.65) {
        print(
          "Contour $i descartado rectangularity=${rectangularity.toStringAsFixed(2)}",
        );
        continue;
      }

      double ratio = rect.width / rect.height;

      if (ratio > 1) {
        ratio = 1 / ratio;
      }

      // if (ratio < 0.45 || ratio > 0.95) {
      //   print(
      //     "Contour $i descartado ratio ${ratio.toStringAsFixed(2)}"
      //   );
      //   continue;
      // }

      final rectCenterX = rect.x + rect.width / 2;
      final rectCenterY = rect.y + rect.height / 2;

      final imageCenterX = image.cols / 2;
      final imageCenterY = image.rows / 2;

      final distance =
          ((rectCenterX - imageCenterX).abs() / image.cols) +
          ((rectCenterY - imageCenterY).abs() / image.rows);

      final centerScore = 1 - distance;

      final borderScore = touchesBorder ? 1.0 : 0.0;

      final sizeScore = (widthRatio + heightRatio) / 2;

      final ratioScore = 1 - (ratio - 0.77).abs();

      final score =
          areaRatio * 0.25 +
          rectangularity * 0.15 +
          centerScore * 0.10 +
          sizeScore * 0.25 +
          borderScore * 0.25;

      print(
        "Contour $i | "
        "AreaRatio: ${areaRatio.toStringAsFixed(2)} | "
        "Rectangularity: ${rectangularity.toStringAsFixed(2)} | "
        "Ratio: ${ratio.toStringAsFixed(2)} | "
        "Score: ${score.toStringAsFixed(2)}",
      );

      if (score > bestScore) {
        bestScore = score;
        bestIndex = i;
      }
    }

    if (bestIndex == null) {
      return null;
    }

    print("MEJOR DOCUMENTO: Contour $bestIndex | Score: $bestScore");

    return DocumentContour(index: bestIndex, contours: contours);
  }
}
