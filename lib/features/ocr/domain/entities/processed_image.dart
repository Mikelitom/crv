class ProcessedImage {
  final String originalPath;

  final String? grayPath;
  final String? blurPath;
  final String? thresholdPath;
  final String? cannyPath;
  final String? contourPath;
  final String? perspectivePath;

  const ProcessedImage({
    required this.originalPath,
    this.grayPath,
    this.blurPath,
    this.thresholdPath,
    this.cannyPath,
    this.contourPath,
    this.perspectivePath,
  });
}