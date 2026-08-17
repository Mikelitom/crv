import 'package:crv_reprosisa/features/ocr/domain/entities/press_checkbox_result.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class PressInspectionResult {
  final List<PressInspectionRow> rows;

  const PressInspectionResult({
    required this.rows,
  });
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