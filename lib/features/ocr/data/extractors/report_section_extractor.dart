import 'package:crv_reprosisa/features/ocr/data/layouts/report_layout.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/extracted_report.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class ReportSectionExtractor {
  const ReportSectionExtractor();

  ExtractedReport extract(cv.Mat image, ReportLayout layout) {
    final sections = <ReportSectionType, cv.Mat>{};

    for (final region in layout.regions) {
      sections[region.type] = _crop(image, region.rect);
    }

    return ExtractedReport(sections: sections);
  }

  cv.Mat _crop(cv.Mat image, cv.Rect rect) {
    if (rect.x < 0 ||
        rect.y < 0 ||
        rect.x + rect.width > image.cols ||
        rect.y + rect.height > image.rows) {
      throw Exception(
        "Region fuerda de limites: $rect en ${image.cols}x${image.rows}",
      );
    }

    return cv.Mat.fromRange(
      image,
      rect.y,
      rect.y + rect.height,
      colStart: rect.x,
      colEnd: rect.x + rect.width,
    ).clone();
  }
}
