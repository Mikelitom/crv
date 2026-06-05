class PressHistory {
  final String pressId, serie, model, type, size, voltz, reportId, folio, state, area, responsibleName, versionId;
  final DateTime inspectionDate;
  final int versionNumber, answersCount, evidencesCount;
  final bool isCurrent;

  PressHistory({
    required this.pressId, required this.serie, required this.model, required this.type,
    required this.size, required this.voltz, required this.reportId, required this.folio,
    required this.state, required this.inspectionDate, required this.area, 
    required this.responsibleName, required this.versionId, required this.versionNumber,
    required this.isCurrent, required this.answersCount, required this.evidencesCount,
  });
}