import 'package:opencv_dart/opencv_dart.dart' as cv;

class ReportRegion {
  final cv.Contours contours;
  final int index;
  final cv.VecPoint corners;

  const ReportRegion({
    required this.contours,
    required this.index,
    required this.corners,
  });
}

class ReportRegionDetector {
  const ReportRegionDetector();

  ReportRegion? detect(cv.Mat binaryImage, cv.Mat originalImage) {
    final result = cv.findContours(
      binaryImage,
      cv.RETR_EXTERNAL,
      cv.CHAIN_APPROX_SIMPLE,
    );

    final contours = result.$1;

    return _findBestContour(contours, originalImage);
  }

  ReportRegion? _findBestContour(cv.Contours contours, cv.Mat image) {
    double bestScore = -1;
    int? bestIndex;

    final imageArea = image.rows * image.cols;
    
    print("Imagen: ${image.cols} x ${image.rows}");
    print("Total de contornos encontrados: ${contours.length}");

    for (int i = 0; i < contours.length; i++) {
      final contour = contours[i];

      final area = cv.contourArea(contour);

      final areaRatio = area / imageArea;

      // print(
      //   "Contour $i areaRatio=${areaRatio.toStringAsFixed(3)}"
      // );

      if (areaRatio < 0.015) {
        // print(
        //   "Contour $i descartado por area: ${areaRatio.toStringAsFixed(3)}",
        // );
        continue;
      }

      if (areaRatio > 0.98) {
        // print(
        //   "Contour $i descartado por area: ${areaRatio.toStringAsFixed(3)}",
        // );
        continue;
      }

      


      final perimeter = cv.arcLength(
        contour,
        true,
      );
      
      final approx = cv.approxPolyDP(
        contour,
        0.015 * perimeter,
        true,
      );

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

      final sizeScore = (widthRatio + heightRatio) / 2;


      final score =
          areaRatio * 0.40 +
          rectangularity * 0.20 +
          centerScore * 0.10 +
          sizeScore * 0.30;

      if (areaRatio > 0.05) {
        print(
          "Contour $i | "
          "Area=${areaRatio.toStringAsFixed(2)} | "
          "Rect=${rectangularity.toStringAsFixed(2)} | "
          "W=${widthRatio.toStringAsFixed(2)} | "
          "H=${heightRatio.toStringAsFixed(2)} | "
          "Score=${score.toStringAsFixed(2)}",
        );
      }

      if (score > bestScore) {
        bestScore = score;
        bestIndex = i;
      }
    }

    if (bestIndex == null) {
      return null;
    }
    
    final bestContour = contours[bestIndex];
    
    final perimeter = cv.arcLength(
      bestContour,
      true,
    );
    
    final approx = cv.approxPolyDP(
      bestContour,
      0.015 * perimeter,
      true,
    );

    
    
    final rect = cv.boundingRect(bestContour);
    
    print(
      "RECT FINAL x:${rect.x} y:${rect.y} "
      "w:${rect.width} h:${rect.height}"
    );
    
    return ReportRegion(
      contours: contours,
      index: bestIndex,
      corners: approx,
    );
  }
}
