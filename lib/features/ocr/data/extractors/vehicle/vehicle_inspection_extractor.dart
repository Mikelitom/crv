import 'package:crv_reprosisa/features/ocr/data/extractors/vehicle/vehicle_checkbox_extractor.dart';
import 'package:crv_reprosisa/features/ocr/data/extractors/vehicle/vehicle_row_extractor.dart';
import 'package:crv_reprosisa/features/ocr/data/extractors/vehicle_inspection_table_extractor.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/vehicle_inspection_result.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class VehicleInspectionExtractor {
  final VehicleInspectionTableExtractor tableExtractor;
  final VehicleInspectionRowExtractor rowExtractor;
  final VehicleCheckboxExtractor checkboxExtractor;

  const VehicleInspectionExtractor({
    required this.tableExtractor,
    required this.rowExtractor,
    required this.checkboxExtractor,
  });

  List<VehicleInspectionResult> extract(cv.Mat inspection) {
    final tables = tableExtractor.extract(inspection);

    final results = <VehicleInspectionResult>[];

    var globalStartIndex = 0;

    for (final table in tables) {
      final rows = rowExtractor.extract(
        inspection,
        table,
        globalStartIndex: globalStartIndex,
      );

      for (final row in rows) {
        final analysis = checkboxExtractor.analyzeRow(inspection, row);

        results.add(VehicleInspectionResult(row: row, analysis: analysis));
      }

      globalStartIndex += table.rowCount;
    }

    return results;
  }
}
