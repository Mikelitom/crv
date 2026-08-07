import 'package:crv_reprosisa/features/ocr/data/layouts/layout_builder.dart';
import 'package:crv_reprosisa/features/ocr/data/layouts/report_layout.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class ConveyorLayout extends LayoutBuilder {
  @override
  ReportLayout build(cv.Mat image) {
    final width = image.cols;
    final height = image.rows;

    return ReportLayout(
      regions: [
        ReportRegionArea(
          type: ReportSectionType.ignore,
          rect: cv.Rect(0, 0, width, (height * 0.14).round()),
        ),
        ReportRegionArea(
          type: ReportSectionType.header,
          rect: cv.Rect(0, (height * 14).round(), width, (height * 0.10).round()),
        ),
        ReportRegionArea(
          type: ReportSectionType.inspection,
          rect: cv.Rect(
            0,
            (height * 0.24).round(),
            width,
            (height * 0.62).round(),
          ),
        ),
        ReportRegionArea(
          type: ReportSectionType.rollers,
          rect: cv.Rect(
            0,
            (height * 0.86).round(),
            width,
            (height * 0.14).round(),
          ),
        ),
      ],
    );
  }
}
