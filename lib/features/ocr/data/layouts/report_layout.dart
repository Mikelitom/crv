import 'package:opencv_dart/opencv_dart.dart' as cv;

enum ReportSectionType { header, inspection, notes, rollers, loan, ignore }

class ReportRegionArea {
  final ReportSectionType type;
  final cv.Rect rect;

  const ReportRegionArea({required this.type, required this.rect});
}

class ReportLayout {
  final List<ReportRegionArea> regions;

  const ReportLayout({required this.regions});
}
