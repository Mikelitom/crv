class PressReportEntity {
  final String pressId;
  final DateTime inspectionDate;
  final String area;
  final String folio;
  final List<PressAnswerEntity> answers;
  final PressLoanEntity? loan; 

  PressReportEntity({
    required this.pressId,
    required this.inspectionDate,
    required this.area,
    required this.folio,
    required this.answers,
    this.loan,
  });
}

class PressLoanEntity {
  final String areaId;
  final DateTime loanDate;
  final String solicitantsName;
  final String observations;

  PressLoanEntity({
    required this.areaId,
    required this.loanDate,
    required this.solicitantsName,
    required this.observations,
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