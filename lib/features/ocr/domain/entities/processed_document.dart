class ProcessedDocument {
  final String originalPath;
  final String processedPath;
  final double confidence;

  const ProcessedDocument({
    required this.originalPath,
    required this.processedPath,
    required this.confidence,
  });
}