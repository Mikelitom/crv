import 'package:opencv_dart/opencv_dart.dart' as cv;

class VehicleInspectionTable {
  final int index;
  final cv.Rect rect;
  final int rowCount;

  const VehicleInspectionTable({
    required this.index,
    required this.rect,
    required this.rowCount,
  });
}
