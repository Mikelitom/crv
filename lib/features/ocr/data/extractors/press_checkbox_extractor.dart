import 'package:crv_reprosisa/features/ocr/domain/entities/checkbox_analysis.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class PressCheckboxExtractor {
  const PressCheckboxExtractor();

  static const double innerMargin = 0.10;

  cv.Mat extract(cv.Mat inspection, cv.Rect rect) {
    final marginX = (rect.width * innerMargin).round();
    final marginY = (rect.height * innerMargin).round();

    final x1 = rect.x + marginX;
    final y1 = rect.y + marginY;
    final x2 = rect.x + rect.width - marginX;
    final y2 = rect.y + rect.height - marginY;

    return cv.Mat.fromRange(
      inspection,
      y1,
      y2,
      colStart: x1,
      colEnd: x2,
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

  void saveDebugRoi(cv.Mat roi, String path) {
    cv.imwrite(path, roi);
  }
}
