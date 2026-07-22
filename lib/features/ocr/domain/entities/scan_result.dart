class ScanResult {
  final String reportType;
  final Map<String, dynamic> generalInfo;
  final Map<String, dynamic> checklist;
  final double confidence;

  const ScanResult({
    required this.reportType,
    required this.generalInfo,
    required this.checklist,
    required this.confidence,
  });
}
