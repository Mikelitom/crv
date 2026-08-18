import 'package:opencv_dart/opencv_dart.dart' as cv;

class VehicleInspectionRow {
  final int globalIndex;
  final int tableIndex;
  final int localIndex;
  final cv.Rect rowRect;

  const VehicleInspectionRow({
    required this.globalIndex,
    required this.tableIndex,
    required this.localIndex,
    required this.rowRect,
  });
}
