import 'package:crv_reprosisa/features/ocr/data/layouts/report_layout.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

abstract class LayoutBuilder {
  ReportLayout build(cv.Mat image);

  cv.Mat drawLayout(cv.Mat image) {
    final output = image.clone();
    final layout = build(image);

    for (final region in layout.regions) {
      cv.rectangle(output, region.rect, cv.Scalar(0, 255, 0), thickness: 3);
    }

    return output;
  }
}
