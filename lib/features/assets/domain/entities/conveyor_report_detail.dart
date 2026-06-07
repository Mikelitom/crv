class ConveyorReportDetail {
  final Map<String, dynamic> report;
  final Map<String, dynamic> conveyor;
  final Map<String, dynamic> version;
  final Map<String, dynamic> inspector;
  final List<Answer> answers;

  ConveyorReportDetail({
    required this.report,
    required this.conveyor,
    required this.version,
    required this.inspector,
    required this.answers,
  });
}

class Answer {
  final String answerId;
  final String sectionName;
  final String accessoryName;
  final String optionLabel;
  final String recommendedAction;
  final double dimensions;
  final List<dynamic> evidences;

  Answer({
    required this.answerId,
    required this.sectionName,
    required this.accessoryName,
    required this.optionLabel,
    required this.recommendedAction,
    required this.dimensions,
    required this.evidences,
  });
}