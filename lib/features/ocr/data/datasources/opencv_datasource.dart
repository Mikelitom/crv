import 'package:crv_reprosisa/features/ocr/data/debug/press_checkbox_debug_renderer.dart';
import 'package:crv_reprosisa/features/ocr/data/detectors/perspective_transformer.dart';
import 'package:crv_reprosisa/features/ocr/data/detectors/report_region_detector.dart';
import 'package:crv_reprosisa/features/ocr/data/layouts/conveyor_layout.dart';
import 'package:crv_reprosisa/features/ocr/data/layouts/report_layout.dart';
import 'package:crv_reprosisa/features/ocr/data/layouts/vehicle_layout.dart';
import 'package:crv_reprosisa/features/ocr/data/preprocessors/document_preprocessor.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/processed_image.dart';
import 'package:crv_reprosisa/features/ocr/data/layouts/press_layout.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/report_type.dart';
import 'package:crv_reprosisa/features/ocr/data/extractors/press_row_extractor.dart';
import 'package:crv_reprosisa/features/ocr/data/debug/press_row_debug_renderer.dart';
import 'package:crv_reprosisa/features/ocr/data/extractors/report_section_extractor.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class OpenCVDataSource {
  final ReportRegionDetector _reportRegionDetector =
      const ReportRegionDetector();
  final DocumentPreprocessor _documentPreprocessor =
      const DocumentPreprocessor();
  final PerspectiveTransformer _perspectiveTransformer =
      const PerspectiveTransformer();
  final PressLayout _pressLayout = PressLayout();
  final VehicleLayout _vehicleLayout = VehicleLayout();
  final ConveyorLayout _conveyorLayout = ConveyorLayout();

  final ReportSectionExtractor _reportSectionExtractor =
      const ReportSectionExtractor();

  final PressRowExtractor _pressRowExtractor = const PressRowExtractor();

  final PressRowDebugRenderer _pressRowDebugRenderer =
      const PressRowDebugRenderer();

  final PressCheckboxDebugRenderer _pressCheckboxDebugRenderer =
      const PressCheckboxDebugRenderer();

  Future<ProcessedImage> processImage(
    String imagePath, {
    required ReportType reportType,
  }) async {
    final original = cv.imread(imagePath);
    final image = _resizeIfNeeded(original);

    if (!identical(original, image)) {
      original.dispose();
    }

    final processed = _documentPreprocessor.process(image);

    // Guardar temporalmente para inspección
    cv.imwrite(_generatePath(imagePath, "closed"), processed.closed);

    final document = _reportRegionDetector.detect(processed.closed, image);

    final perspective = document == null
        ? image.clone()
        : _perspectiveTransformer.transform(image, document);

    final reportLayout = switch (reportType) {
      ReportType.press => _pressLayout.build(perspective),
      ReportType.vehicle => _vehicleLayout.build(perspective),
      ReportType.conveyor => _conveyorLayout.build(perspective),
    };

    final layout = switch (reportType) {
      ReportType.press => _pressLayout.drawLayout(perspective, reportLayout),
      ReportType.vehicle => _vehicleLayout.drawLayout(
        perspective,
        reportLayout,
      ),
      ReportType.conveyor => _conveyorLayout.drawLayout(
        perspective,
        reportLayout,
      ),
    };

    final extractedReport = _reportSectionExtractor.extract(
      perspective,
      reportLayout,
    );

    String? pressRowsPath;
    String? pressCheckboxesPath;

    if (reportType == ReportType.press) {
      final inspection = extractedReport.sections[ReportSectionType.inspection];

      if (inspection != null) {
        final rowRects = _pressRowExtractor.getRowRects(inspection);

        // Debug de las 23 filas
        final rowsDebug = _pressRowDebugRenderer.drawRows(inspection, rowRects);

        pressRowsPath = _generatePath(imagePath, "press_rows");

        cv.imwrite(pressRowsPath, rowsDebug);

        // Debug de las casillas
        final checkboxDebug = _pressCheckboxDebugRenderer.drawCheckboxes(
          inspection,
          rowRects,
          goodX: 855,
          badX: 930,
          checkboxWidth: 70,
          checkboxHeight: 40,
        );

        pressCheckboxesPath = _generatePath(imagePath, "press_checkboxes");

        cv.imwrite(pressCheckboxesPath, checkboxDebug);
      }
    }
    final contour = _drawDocumentContour(image, document);

    return _saveResults(
      imagePath: imagePath,
      gray: processed.gray,
      contour: contour,
      threshold: processed.threshold,
      closed: processed.closed,
      perspective: perspective,
      layout: layout,
      pressRowsPath: pressRowsPath,
      pressCheckboxesPath: pressCheckboxesPath,
    );
  }

  cv.Mat _drawDocumentContour(cv.Mat original, ReportRegion? document) {
    final output = original.clone();

    if (document == null) {
      print("No se encontró región del reporte");
      return output;
    }

    cv.drawContours(
      output,
      document.contours,
      document.index,
      cv.Scalar(0, 255, 0),
      thickness: 4,
    );

    return output;
  }

  cv.Mat _resizeIfNeeded(cv.Mat image, {int maxDimension = 2000}) {
    final width = image.cols;
    final height = image.rows;

    final scale = width > height ? maxDimension / width : maxDimension / height;

    if (scale >= 1) {
      return image.clone();
    }

    final newWidth = (width * scale).round();
    final newHeight = (height * scale).round();

    return cv.resize(image, (
      newWidth,
      newHeight,
    ), interpolation: cv.INTER_AREA);
  }

  ProcessedImage _saveResults({
    required String imagePath,
    required cv.Mat gray,
    required cv.Mat contour,
    required cv.Mat threshold,
    required cv.Mat closed,
    required cv.Mat perspective,
    required cv.Mat layout,
    String? pressRowsPath,
    String? pressCheckboxesPath,
  }) {
    final grayPath = _generatePath(imagePath, "gray");

    final contourPath = _generatePath(imagePath, "contour");

    final thresholdPath = _generatePath(imagePath, "threshold");

    final closedPath = _generatePath(imagePath, "closed");

    final perspectivePath = _generatePath(imagePath, "perspective");

    final layoutPath = _generatePath(imagePath, "layout");

    cv.imwrite(grayPath, gray);
    cv.imwrite(contourPath, contour);
    cv.imwrite(thresholdPath, threshold);
    cv.imwrite(closedPath, closed);
    cv.imwrite(perspectivePath, perspective);
    cv.imwrite(layoutPath, layout);

    return ProcessedImage(
      originalPath: imagePath,
      grayPath: grayPath,
      contourPath: contourPath,
      thresholdPath: thresholdPath,
      closedPath: closedPath,
      perspectivePath: perspectivePath,
      layoutPath: layoutPath,
      pressRowsPath: pressRowsPath,
      pressCheckboxesPath: pressCheckboxesPath,
    );
  }

  String _generatePath(String originalPath, String suffix) {
    final index = originalPath.lastIndexOf(".");

    if (index == -1) {
      return "${originalPath}_$suffix";
    }

    final name = originalPath.substring(0, index);
    final extension = originalPath.substring(index);

    return "${name}_$suffix$extension";
  }
}
