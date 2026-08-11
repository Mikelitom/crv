import 'package:crv_reprosisa/features/ocr/data/layouts/report_layout.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class ExtractedReport {
  final Map<ReportSectionType, cv.Mat> sections;

  const ExtractedReport({required this.sections});

  cv.Mat? operator [](ReportSectionType type) => sections[type];

  bool contains(ReportSectionType type) => sections.containsKey(type);
}
