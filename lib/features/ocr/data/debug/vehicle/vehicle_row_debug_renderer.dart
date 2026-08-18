import 'package:crv_reprosisa/features/ocr/domain/entities/vehicle_inspection_row.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class VehicleRowDebugRenderer {
  const VehicleRowDebugRenderer();

  cv.Mat drawRows(cv.Mat inspection, List<VehicleInspectionRow> rows) {
    final output = inspection.clone();

    for (final row in rows) {
      cv.rectangle(output, row.rowRect, cv.Scalar(0, 255, 0), thickness: 2);

      cv.putText(
        output,
        '${row.globalIndex}',
        cv.Point(row.rowRect.x + 5, row.rowRect.y + 20),
        cv.FONT_HERSHEY_SIMPLEX,
        0.6,
        cv.Scalar(0, 0, 255),
        thickness: 2,
      );
    }

    return output;
  }
}
