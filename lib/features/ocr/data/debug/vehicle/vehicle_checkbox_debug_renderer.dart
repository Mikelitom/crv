import 'package:crv_reprosisa/features/ocr/data/layouts/inspections/vehicle_inspection_layout.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/vehicle_inspection_row.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class VehicleCheckboxDebugRenderer {
  final VehicleInspectionLayout layout;

  const VehicleCheckboxDebugRenderer({required this.layout});

  cv.Mat drawCheckboxes(cv.Mat inspection, List<VehicleInspectionRow> rows) {
    final output = inspection.clone();

    for (final row in rows) {
      final good = layout.goodRect(inspection, row.rowRect);

      final bad = layout.badRect(inspection, row.rowRect);

      final reposition = layout.repositionRect(inspection, row.rowRect);

      final repair = layout.repairRect(inspection, row.rowRect);

      cv.rectangle(output, good, cv.Scalar(0, 255, 0), thickness: 2);

      cv.rectangle(output, bad, cv.Scalar(0, 255, 0), thickness: 2);

      cv.rectangle(output, reposition, cv.Scalar(0, 255, 0), thickness: 2);

      cv.rectangle(output, repair, cv.Scalar(0, 255, 0), thickness: 2);

      cv.putText(
        output,
        '${row.globalIndex}',
        cv.Point(row.rowRect.x + 5, row.rowRect.y + 20),
        cv.FONT_HERSHEY_SIMPLEX,
        0.5,
        cv.Scalar(0, 0, 255),
        thickness: 1,
      );
    }

    return output;
  }
}
