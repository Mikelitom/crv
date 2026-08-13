import 'package:crv_reprosisa/features/ocr/domain/entities/press_checkbox_result.dart';

class PressInspectionClassifier {
  const PressInspectionClassifier();

  static const double minMarkedRatio = 0.08;
  static const double minDifference = 0.005;

  PressCheckboxResult classify({
    required double goodRatio,
    required double badRatio,
  }) {
    final difference = (goodRatio - badRatio).abs();

    if (goodRatio < minMarkedRatio && badRatio < minMarkedRatio) {
      return PressCheckboxResult.none;
    }

    if (difference <= minDifference) {
      return PressCheckboxResult.none;
    }

    if (goodRatio > badRatio) {
      return PressCheckboxResult.good;
    }

    return PressCheckboxResult.bad;
  }
}
