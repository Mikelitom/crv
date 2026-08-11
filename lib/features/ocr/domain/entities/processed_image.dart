class ProcessedImage {
  final String originalPath;

  final String? grayPath;
  final String? blurPath;
  final String? thresholdPath;
  final String? medianPath;
  final String? cannyPath;
  final String? contourPath;
  final String? perspectivePath;
  final String? clahePath;
  final String? dilatedPath;
  final String? closedPath;
  final String? layoutPath;

  final String? pressRowsPath;
  final String? pressCheckboxesPath;

  const ProcessedImage({
    required this.originalPath,
    this.grayPath,
    this.blurPath,
    this.thresholdPath,
    this.medianPath,
    this.cannyPath,
    this.contourPath,
    this.perspectivePath,
    this.clahePath,
    this.dilatedPath,
    this.closedPath,
    this.layoutPath,
    this.pressRowsPath,
    this.pressCheckboxesPath,
  });
}
