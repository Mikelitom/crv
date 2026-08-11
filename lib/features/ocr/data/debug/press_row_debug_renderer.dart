import 'package:opencv_dart/opencv_dart.dart' as cv;

class PressRowDebugRenderer {
  const PressRowDebugRenderer();

  cv.Mat drawRows(cv.Mat inspection, List<cv.Rect> rowRects) {
    final output = inspection.clone();

    for (int i = 0; i < rowRects.length; i++) {
      final rect = rowRects[i];

      cv.rectangle(output, rect, cv.Scalar(0, 255, 0), thickness: 2);

      cv.putText(
        output,
        '$i',
        cv.Point(rect.x + 10, rect.y + 25),
        cv.FONT_HERSHEY_SIMPLEX,
        0.7,
        cv.Scalar(0, 0, 255),
        thickness: 2,
      );
    }

    return output;
  }
}
