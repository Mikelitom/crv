import 'package:opencv_dart/opencv_dart.dart' as cv;

class PressCheckboxDebugRenderer {
  const PressCheckboxDebugRenderer();

  cv.Mat drawCheckboxes(
    cv.Mat inspection,
    List<cv.Rect> rowRects, {
    required int goodX,
    required int badX,
    required int checkboxWidth,
    required int checkboxHeight,
  }) {
    final output = inspection.clone();

    for (int i = 0; i < rowRects.length; i++) {
      final row = rowRects[i];

      final checkboxY = row.y + ((row.height - checkboxHeight) / 2).round();

      final goodRect = cv.Rect(goodX, checkboxY, checkboxWidth, checkboxHeight);

      final badRect = cv.Rect(badX, checkboxY, checkboxWidth, checkboxHeight);

      // Buena
      cv.rectangle(output, goodRect, cv.Scalar(0, 255, 0), thickness: 2);

      // Mala
      cv.rectangle(output, badRect, cv.Scalar(0, 0, 255), thickness: 2);

      // Número de fila
      cv.putText(
        output,
        '$i',
        cv.Point(row.x + 10, row.y + 25),
        cv.FONT_HERSHEY_SIMPLEX,
        0.6,
        cv.Scalar(255, 0, 0),
        thickness: 2,
      );
    }

    return output;
  }
}
