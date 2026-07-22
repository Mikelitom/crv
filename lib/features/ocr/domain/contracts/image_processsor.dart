import 'dart:io';

import 'package:crv_reprosisa/features/ocr/domain/entities/scan_result.dart';

abstract class ImageProcessor {
  Future<ScanResult> process(File image);
}
