import 'package:crv_reprosisa/features/ocr/data/extractors/press_checkbox_extractor.dart';
import 'package:crv_reprosisa/features/ocr/data/extractors/press_row_extractor.dart';
import 'package:crv_reprosisa/features/ocr/data/layouts/inspections/press_inspection_layout.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/press_checkbox_result.dart';
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

  final double goodRatio;
  final double badRatio;

  final PressCheckboxResult result;

  const PressInspectionRow({
    required this.index,
    required this.rowRect,
    required this.goodRect,
    required this.badRect,
    required this.goodRatio,
    required this.badRatio,
    required this.result,
  });
}

class PressInspectionExtractor {
  final PressRowExtractor rowExtractor;
  final PressInspectionLayout layout;
  final PressCheckboxExtractor checkboxExtractor;

  const PressInspectionExtractor({
    required this.rowExtractor,
    required this.layout,
    required this.checkboxExtractor,
  });

  PressInspectionResult extract(cv.Mat inspection) {
    final rowRects = rowExtractor.getRowRects(inspection);

    final rows = <PressInspectionRow>[];

    for (int i = 0; i < rowRects.length; i++) {
      final row = rowRects[i];

      final goodRect = layout.goodRect(inspection, row);

      final badRect = layout.badRect(inspection, row);

      final goodRoi = checkboxExtractor.extract(inspection, goodRect);

      final badRoi = checkboxExtractor.extract(inspection, badRect);

      final goodAnalysis = checkboxExtractor.analyze(goodRoi);

      final badAnalysis = checkboxExtractor.analyze(badRoi);

      final result = _determineResult(
        goodAnalysis.darkPixelRatio,
        badAnalysis.darkPixelRatio,
      );

      print(
        'Fila $i | '
        'GOOD: ${(goodAnalysis.darkPixelRatio * 100).toStringAsFixed(2)}% | '
        'BAD: ${(badAnalysis.darkPixelRatio * 100).toStringAsFixed(2)}% | '
        'DIF: ${((goodAnalysis.darkPixelRatio - badAnalysis.darkPixelRatio).abs() * 100).toStringAsFixed(2)}% | '
        'RESULT: $result',
      );

      goodRoi.dispose();
      badRoi.dispose();

      rows.add(
        PressInspectionRow(
          index: i,
          rowRect: row,
          goodRect: goodRect,
          badRect: badRect,
          goodRatio: goodAnalysis.darkPixelRatio,
          badRatio: badAnalysis.darkPixelRatio,
          result: result,
        ),
      );
    }

    return PressInspectionResult(rows: rows);
  }

  PressCheckboxResult _determineResult(double goodRatio, double badRatio) {
    const minimumDifference = 0.02;

    final difference = (goodRatio - badRatio).abs();

    if (difference < minimumDifference) {
      return PressCheckboxResult.none;
    }

    if (goodRatio > badRatio) {
      return PressCheckboxResult.good;
    }

    return PressCheckboxResult.bad;
  }
}
