class PressReportEntity {
  final String pressId;
  final String responsibleId;
  final DateTime inspectionDate;
  final String area;
  final String folio;
  final List<PressAnswerEntity> answers;

  PressReportEntity({
    required this.pressId,
    required this.responsibleId,
    required this.inspectionDate,
    required this.area,
    required this.folio,
    required this.answers,
  });
}

class PressAnswerEntity {
  final String componentId;
  final int quantity;
  final String status;
  final String observation;

  PressAnswerEntity({
    required this.componentId,
    required this.quantity,
    required this.status,
    required this.observation,
  });
}