import 'package:opencv_dart/opencv_dart.dart' as cv;

class PressInspectionLayout {
  static const int rowCount = 23;

  // Columnas de respuesta dentro de la sección de inspección.
  static const double goodStart = 0.65;
  static const double goodEnd = 0.71;

  static const double badStart = 0.71;
  static const double badEnd = 0.76;

  const PressInspectionLayout();

  cv.Rect goodRect(cv.Mat inspection, cv.Rect row) {
    final x = (inspection.cols * goodStart).round();

    final width = (inspection.cols * (goodEnd - goodStart)).round();

    return cv.Rect(x, row.y, width, row.height);
  }

  cv.Rect badRect(cv.Mat inspection, cv.Rect row) {
    final x = (inspection.cols * badStart).round();

    final width = (inspection.cols * (badEnd - badStart)).round();

    return cv.Rect(x, row.y, width, row.height);
  }
}
