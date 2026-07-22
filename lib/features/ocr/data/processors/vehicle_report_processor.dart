import 'dart:io';


import 'package:crv_reprosisa/features/ocr/domain/repositories/image_processsor.dart';

import '../../domain/entities/scan_result.dart';


class VehicleReportProcessor implements ImageProcessor {


  @override
  Future<ScanResult> process(File image) async {


    // Después aquí irá:
    // - OpenCV
    // - recorte de regiones
    // - ML Kit


    return const ScanResult(
      reportType: "VEHICLE",
      generalInfo: {
        "test": "ok"
      },
      checklist: {},
      confidence: 0,
    );

  }

}