enum PressCheckboxResult { good, bad, none, uncertain }

class PressInspectionClassifier {
  const PressInspectionClassifier();

  PressCheckboxResult classify({
    required double goodRatio,
    required double badRatio,
  }) {
    final difference = (goodRatio - badRatio).abs();

    // Prácticamente iguales.
    if (difference <= 0.01) {
      return PressCheckboxResult.none;
    }

    if (goodRatio > badRatio) {
      return PressCheckboxResult.good;
    }

    return PressCheckboxResult.bad;
  }
}
