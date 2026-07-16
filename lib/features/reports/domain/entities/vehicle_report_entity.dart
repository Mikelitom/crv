class VehicleReportEntity {
  final String reportId;
  final String plate;
  final String folio;
  final String state;
  final String responsibleName;
  final int versionNumber;
  final DateTime inspectionDate;

  VehicleReportEntity({
    required this.reportId,
    required this.plate,
    required this.folio,
    required this.state,
    required this.responsibleName,
    required this.versionNumber,
    required this.inspectionDate,
  });
}