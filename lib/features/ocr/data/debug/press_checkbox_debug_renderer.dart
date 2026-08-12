import 'package:crv_reprosisa/features/ocr/data/extractors/press_checkbox_extractor.dart';
import 'package:crv_reprosisa/features/ocr/data/extractors/press_inspection_extractor.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class PressCheckboxDebugRenderer {
  final PressCheckboxExtractor checkboxExtractor;

  const PressCheckboxDebugRenderer({
    this.checkboxExtractor = const PressCheckboxExtractor(),
  });

  cv.Mat drawCheckboxes(cv.Mat inspection, PressInspectionResult result) {
    const int padding = 20;
    const int labelHeight = 35;
    const int columnGap = 20;
    const int rowGap = 15;

    if (result.rows.isEmpty) {
      return inspection.clone();
    }

    final firstRow = result.rows.first;

    final firstGood = checkboxExtractor.extract(inspection, firstRow.goodRect);

    final checkboxWidth = firstGood.cols;
    final checkboxHeight = firstGood.rows;

    firstGood.dispose();

    final cellHeight = checkboxHeight + labelHeight;

    final outputWidth = padding * 2 + checkboxWidth * 2 + columnGap;

    final outputHeight =
        padding * 2 +
        cellHeight * result.rows.length +
        rowGap * (result.rows.length - 1);

    final output = cv.Mat.zeros(outputHeight, outputWidth, cv.MatType.CV_8UC3);

    for (final row in result.rows) {
      final good = checkboxExtractor.extract(inspection, row.goodRect);

      final bad = checkboxExtractor.extract(inspection, row.badRect);

      final y = padding + row.index * (cellHeight + rowGap);

      final goodX = padding;

      final badX = padding + checkboxWidth + columnGap;

      _drawRoi(output, good, x: goodX, y: y, label: 'Fila ${row.index} - GOOD');

      _drawRoi(output, bad, x: badX, y: y, label: 'Fila ${row.index} - BAD');

      good.dispose();
      bad.dispose();
    }

    return output;
  }

  void _drawRoi(
    cv.Mat output,
    cv.Mat roi, {
    required int x,
    required int y,
    required String label,
  }) {
    cv.putText(
      output,
      label,
      cv.Point(x, y + 25),
      cv.FONT_HERSHEY_SIMPLEX,
      0.6,
      cv.Scalar(255, 255, 255),
      thickness: 2,
    );

    final roiY = y + 35;

    final destination = cv.Mat.fromRange(
      output,
      roiY,
      roiY + roi.rows,
      colStart: x,
      colEnd: x + roi.cols,
    );

    roi.copyTo(destination);

    destination.dispose();
  }
}
