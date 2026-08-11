import 'package:crv_reprosisa/features/ocr/data/extractors/press_inspection_extractor.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class PressCheckboxDebugRenderer {
  const PressCheckboxDebugRenderer();

  cv.Mat drawCheckboxes(cv.Mat inspection, PressInspectionResult result) {
    final output = inspection.clone();

    for (final row in result.rows) {
      // Buena
      cv.rectangle(output, row.goodRect, cv.Scalar(0, 255, 0), thickness: 2);

      // Mala
      cv.rectangle(output, row.badRect, cv.Scalar(0, 0, 255), thickness: 2);

      // Número de fila
      cv.putText(
        output,
        '${row.index}',
        cv.Point(row.rowRect.x + 10, row.rowRect.y + 25),
        cv.FONT_HERSHEY_SIMPLEX,
        0.6,
        cv.Scalar(255, 0, 0),
        thickness: 2,
      );
    }

    return output;
  }
}
