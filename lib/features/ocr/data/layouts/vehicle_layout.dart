import 'package:crv_reprosisa/features/ocr/data/layouts/report_layout.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class VehicleLayout {
  ReportLayout build(cv.Mat image) {
    final width = image.cols;
    final height = image.rows;

    return ReportLayout(
      regions: [
        ReportRegionArea(
          name: 'header',
          rect: cv.Rect(0, 0, width, (height * 0.3).round()),
        ),
        ReportRegionArea(
          name: 'report',
          rect: cv.Rect(
            0,
            (height * 0.3).round(),
            width,
            (height * 0.5).round(),
          ),
        ),
        ReportRegionArea(
          name: 'service',
          rect: cv.Rect(
            0,
            (height * 0.8).round(),
            width,
            (height * 0.2).round(),
          ),
        ),
      ],
    );
  }
}
