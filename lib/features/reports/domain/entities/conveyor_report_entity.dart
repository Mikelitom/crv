class ConveyorReportEntity {
  final String reportId;
  final String folio;
  final String state;
  final String conveyorName;
  final String clientCompany;
  final String inspectorName;
  final int versionNumber;
  final DateTime inspectionDate;

  ConveyorReportEntity({
    required this.reportId, required this.folio, required this.state,
    required this.conveyorName, required this.clientCompany,
    required this.inspectorName, required this.versionNumber,
    required this.inspectionDate,
  });
}