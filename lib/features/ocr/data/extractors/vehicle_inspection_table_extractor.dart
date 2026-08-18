import 'package:crv_reprosisa/features/ocr/domain/entities/vehicle_inspection_table.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class VehicleInspectionTableExtractor {
  const VehicleInspectionTableExtractor();

  List<VehicleInspectionTable> extract(cv.Mat inspection) {
    final width = inspection.cols;
    final height = inspection.rows;

    const table1Top = 0.00;
    const table1Bottom = 0.225;

    const table2Top = 0.285;
    const table2Bottom = 0.72;

    const table3Top = 0.767;
    const table3Bottom = 1.00;

    return [
      VehicleInspectionTable(
        index: 0,
        rect: cv.Rect(
          0,
          (height * table1Top).round(),
          width,
          (height * (table1Bottom - table1Top)).round(),
        ),
        rowCount: 9,
      ),
      VehicleInspectionTable(
        index: 1,
        rect: cv.Rect(
          0,
          (height * table2Top).round(),
          width,
          (height * (table2Bottom - table2Top)).round(),
        ),
        rowCount: 15,
      ),
      VehicleInspectionTable(
        index: 2,
        rect: cv.Rect(
          0,
          (height * table3Top).round(),
          width,
          (height * (table3Bottom - table3Top)).round(),
        ),
        rowCount: 10,
      ),
    ];
  }
}
