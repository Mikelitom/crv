import 'package:opencv_dart/opencv_dart.dart' as cv;

class VehicleInspectionLayout {
  const VehicleInspectionLayout();

  static const double goodStart = 0;
  static const double goodEnd = 0.191;

  static const double badStart = 0.191;
  static const double badEnd = 0.41;

  static const double repositionStart = 0.41;
  static const double repositionEnd = 0.705;

  static const double repairStart = 0.705;
  static const double repairEnd = 1;

  cv.Rect goodRect(cv.Mat inspection, cv.Rect row) {
    return _columnRect(inspection, row, goodStart, goodEnd);
  }

  cv.Rect badRect(cv.Mat inspection, cv.Rect row) {
    return _columnRect(inspection, row, badStart, badEnd);
  }

  cv.Rect repositionRect(cv.Mat inspection, cv.Rect row) {
    return _columnRect(inspection, row, repositionStart, repositionEnd);
  }

  cv.Rect repairRect(cv.Mat inspection, cv.Rect row) {
    return _columnRect(inspection, row, repairStart, repairEnd);
  }

  cv.Rect _columnRect(
    cv.Mat inspection,
    cv.Rect row,
    double start,
    double end,
  ) {
    final x = (inspection.cols * start).round();

    final width = (inspection.cols * (end - start)).round();

    return cv.Rect(x, row.y, width, row.height);
  }
}
