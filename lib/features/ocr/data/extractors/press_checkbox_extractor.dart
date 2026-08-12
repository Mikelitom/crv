import 'package:crv_reprosisa/features/ocr/domain/entities/checkbox_analysis.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class PressCheckboxExtractor {
  const PressCheckboxExtractor();

  cv.Mat extract(cv.Mat inspection, cv.Rect rect) {
    return cv.Mat.fromRange(
      inspection,
      rect.y,
      rect.y + rect.height,
      colStart: rect.x,
      colEnd: rect.x + rect.width,
    ).clone();
  }

  CheckboxAnalysis analyze(cv.Mat roi) {
    final gray = cv.cvtColor(roi, cv.COLOR_BGR2GRAY);

    final thresholdResult = cv.threshold(
      gray,
      0,
      255,
      cv.THRESH_BINARY_INV + cv.THRESH_OTSU,
    );

    final threshold = thresholdResult.$2;

    final totalPixels = threshold.rows * threshold.cols;

    final darkPixels = cv.countNonZero(threshold);

    final darkPixelRatio = darkPixels / totalPixels;

    gray.dispose();
    threshold.dispose();

    return CheckboxAnalysis(darkPixelRatio: darkPixelRatio);
  }
}
