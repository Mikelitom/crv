import 'package:crv_reprosisa/features/ocr/data/layouts/layout_builder.dart';
import 'package:crv_reprosisa/features/ocr/data/layouts/report_layout.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class PressLayout extends LayoutBuilder {
  @override
  ReportLayout build(cv.Mat image) {
    final width = image.cols;
    final height = image.rows;

    return ReportLayout(
      regions: [
        ReportRegionArea(
          type: ReportSectionType.inspection,
          rect: cv.Rect(
            0,
            (height * 0.04).round(),
            width,
            (height * 0.74).round(),
          ),
        ),
        ReportRegionArea(
          type: ReportSectionType.loan,
          rect: cv.Rect(
            0,
            (height * 0.78).round(),
            width,
            (height * 0.22).round(),
          ),
        ),
      ],
    );
  }
}
