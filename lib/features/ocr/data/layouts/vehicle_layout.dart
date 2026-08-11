import 'package:crv_reprosisa/features/ocr/data/layouts/layout_builder.dart';
import 'package:crv_reprosisa/features/ocr/data/layouts/report_layout.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class VehicleLayout extends LayoutBuilder {
  @override
  ReportLayout build(cv.Mat image) {
    final width = image.cols;
    final height = image.rows;

    return ReportLayout(
      regions: [
        ReportRegionArea(
          type: ReportSectionType.ignore,
          rect: cv.Rect(0, 0, width, (height * 0.09).round()),
        ),
        ReportRegionArea(
          type: ReportSectionType.header,
          rect: cv.Rect(
            0,
            (height * 0.09).round(),
            width,
            (height * 0.09).round(),
          ),
        ),
        ReportRegionArea(
          type: ReportSectionType.inspection,
          rect: cv.Rect(
            0,
            (height * 0.18).round(),
            (width * 0.64).round(),
            (height * 0.71).round(),
          ),
        ),
        ReportRegionArea(
          type: ReportSectionType.notes,
          rect: cv.Rect(
            0,
            (height * 0.89).round(),
            width,
            (height * 0.11).round(),
          ),
        ),
      ],
    );
  }
}
