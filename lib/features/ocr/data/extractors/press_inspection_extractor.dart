import 'package:crv_reprosisa/features/ocr/data/extractors/press_row_extractor.dart';
import 'package:crv_reprosisa/features/ocr/data/layouts/inspections/press_inspection_layout.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class PressInspectionResult {
  final List<PressInspectionRow> rows;

  const PressInspectionResult({required this.rows});
}

class PressInspectionRow {
  final int index;
  final cv.Rect rowRect;
  final cv.Rect goodRect;
  final cv.Rect badRect;

  const PressInspectionRow({
    required this.index,
    required this.rowRect,
    required this.goodRect,
    required this.badRect,
  });
}

class PressInspectionExtractor {
  final PressRowExtractor rowExtractor;
  final PressInspectionLayout layout;

  const PressInspectionExtractor({
    required this.rowExtractor,
    required this.layout,
  });

  PressInspectionResult extract(cv.Mat inspection) {
    final rowRects = rowExtractor.getRowRects(inspection);

    final rows = <PressInspectionRow>[];

    for (int i = 0; i < rowRects.length; i++) {
      final row = rowRects[i];

      final goodRect = layout.goodRect(inspection, row);

      final badRect = layout.badRect(inspection, row);

      rows.add(
        PressInspectionRow(
          index: i,
          rowRect: row,
          goodRect: goodRect,
          badRect: badRect,
        ),
      );
    }

    return PressInspectionResult(rows: rows);
  }
}
