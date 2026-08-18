import 'package:crv_reprosisa/features/ocr/domain/entities/checkbox_analysis.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/vehicle_checkbox_analysis.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/vehicle_inspection_row.dart';
import 'package:crv_reprosisa/features/ocr/data/layouts/inspections/vehicle_inspection_layout.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class VehicleCheckboxExtractor {
  final VehicleInspectionLayout layout;

  const VehicleCheckboxExtractor({required this.layout});

  static const double innerMarginX = 0.20;
  static const double innerMarginY = 0.20;

  VehicleCheckboxAnalysis analyzeRow(
    cv.Mat inspection,
    VehicleInspectionRow row,
  ) {
    final goodRect = layout.goodRect(inspection, row.rowRect);

    final badRect = layout.badRect(inspection, row.rowRect);

    final repositionRect = layout.repositionRect(inspection, row.rowRect);

    final repairRect = layout.repairRect(inspection, row.rowRect);

    final goodRoi = _extract(inspection, goodRect);

    final badRoi = _extract(inspection, badRect);

    final repositionRoi = _extract(inspection, repositionRect);

    final repairRoi = _extract(inspection, repairRect);

    try {
      return VehicleCheckboxAnalysis(
        good: _analyze(goodRoi),
        bad: _analyze(badRoi),
        reposition: _analyze(repositionRoi),
        repair: _analyze(repairRoi),
      );
    } finally {
      goodRoi.dispose();
      badRoi.dispose();
      repositionRoi.dispose();
      repairRoi.dispose();
    }
  }

  cv.Mat _extract(cv.Mat image, cv.Rect rect) {
    final marginX = (rect.width * innerMarginX).round();
    final marginY = (rect.height * innerMarginY).round();

    final x1 = rect.x + marginX;
    final y1 = rect.y + marginY;

    final x2 = rect.x + rect.width - marginX;
    final y2 = rect.y + rect.height - marginY;

    return cv.Mat.fromRange(image, y1, y2, colStart: x1, colEnd: x2).clone();
  }

  CheckboxAnalysis _analyze(cv.Mat roi) {
    final gray = cv.cvtColor(roi, cv.COLOR_BGR2GRAY);

    final threshold = cv.adaptiveThreshold(
      gray,
      255,
      cv.ADAPTIVE_THRESH_GAUSSIAN_C,
      cv.THRESH_BINARY_INV,
      11,
      5,
    );

    try {
      final totalPixels = threshold.rows * threshold.cols;

      if (totalPixels == 0) {
        return const CheckboxAnalysis(darkPixelRatio: 0);
      }

      final darkPixels = cv.countNonZero(threshold);

      return CheckboxAnalysis(darkPixelRatio: darkPixels / totalPixels);
    } finally {
      gray.dispose();
      threshold.dispose();
    }
  }
}
