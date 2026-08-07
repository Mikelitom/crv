import 'package:opencv_dart/opencv_dart.dart' as cv;

class PressRowExtractor {
  static const int rowCount = 23;

  const PressRowExtractor();

  List<cv.Rect> getRowRects(cv.Mat inspection) {
    final rowHeight = inspection.rows / rowCount;

    return List.generate(rowCount, (i) {
      final startY = (i * rowHeight).round();
      final endY = ((i + 1) * rowHeight).round();

      return cv.Rect(0, startY, inspection.cols, endY - startY);
    });
  }

  List<cv.Mat> extract(cv.Mat inspection) {
    final rects = getRowRects(inspection);

    return rects.map((rect) {
      return cv.Mat.fromRange(
        inspection,
        rect.y,
        rect.y + rect.height,
        colStart: rect.x,
        colEnd: rect.x + rect.width,
      ).clone();
    }).toList();
  }
}
