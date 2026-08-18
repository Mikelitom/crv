import 'package:crv_reprosisa/features/ocr/domain/entities/vehicle_inspection_row.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/vehicle_inspection_table.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class VehicleInspectionRowExtractor {
  const VehicleInspectionRowExtractor();

  List<VehicleInspectionRow> extract(
    cv.Mat inspection,
    VehicleInspectionTable table, {
    required int globalStartIndex,
  }) {
    final rows = <VehicleInspectionRow>[];

    final rowHeight = table.rect.height / table.rowCount;

    for (var localIndex = 0; localIndex < table.rowCount; localIndex++) {
      final y1 = table.rect.y + (localIndex * rowHeight).round();

      final y2 = table.rect.y + ((localIndex + 1) * rowHeight).round();

      final rowRect = cv.Rect(table.rect.x, y1, table.rect.width, y2 - y1);

      rows.add(
        VehicleInspectionRow(
          globalIndex: globalStartIndex + localIndex,
          tableIndex: table.index,
          localIndex: localIndex,
          rowRect: rowRect,
        ),
      );
    }

    return rows;
  }
}
