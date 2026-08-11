import 'package:opencv_dart/opencv_dart.dart' as cv;

class PressCheckboxRegion {
  final int rowIndex;
  final cv.Rect good;
  final cv.Rect bad;

  const PressCheckboxRegion({
    required this.rowIndex,
    required this.good,
    required this.bad,
  });
}
