import 'package:crv_reprosisa/features/ocr/data/layouts/report_layout.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class PressLayout {
  ReportLayout build(cv.Mat image) {
    final width = image.cols;
    final height = image.rows;

    return ReportLayout(
      regions: [
        ReportRegionArea(
          name: 'inspection',
          rect: cv.Rect(0, 0, width, (height * 0.7).round()),
        ),
        ReportRegionArea(
          name: 'loan',
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

  cv.Mat drawLayout(cv.Mat image) {
    final output = image.clone();
    final layout = build(image);

    for (final region in layout.regions) {
      cv.rectangle(output, region.rect, cv.Scalar(0, 255, 0), thickness: 3);
    }

    return output;
  }
}
