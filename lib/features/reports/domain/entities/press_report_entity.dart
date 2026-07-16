class PressReportEntity {
  final String reportId;
  final String folio;
  final String state;
  final String serie;
  final String responsibleName;
  final int versionNumber;
  final DateTime inspectionDate;

  PressReportEntity({
    required this.reportId, required this.folio, required this.state,
    required this.serie, required this.responsibleName,
    required this.versionNumber, required this.inspectionDate,
  });
}