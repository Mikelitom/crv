import 'package:crv_reprosisa/features/ocr/domain/entities/vehicle_inspection_table.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class VehicleInspectionTableDebugRenderer {
  const VehicleInspectionTableDebugRenderer();

  cv.Mat drawTables(cv.Mat image, List<VehicleInspectionTable> tables) {
    final output = image.clone();

    for (final table in tables) {
      cv.rectangle(output, table.rect, cv.Scalar(0, 255, 0), thickness: 4);
    }

    return output;
  }
}
