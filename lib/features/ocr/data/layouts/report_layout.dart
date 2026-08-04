import 'package:opencv_dart/opencv_dart.dart' as cv;

class ReportRegionArea {
  final String name;
  final cv.Rect rect;

  const ReportRegionArea({required this.name, required this.rect});
}

class ReportLayout {
  final List<ReportRegionArea> regions;

  const ReportLayout({required this.regions});
}
