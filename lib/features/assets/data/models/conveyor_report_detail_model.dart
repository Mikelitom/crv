import '../../domain/entities/conveyor_report_detail.dart';

class ConveyorReportDetailModel extends ConveyorReportDetail {
  ConveyorReportDetailModel({
    required super.report,
    required super.conveyor,
    required super.version,
    required super.inspector,
    required super.answers,
  });

  factory ConveyorReportDetailModel.fromJson(Map<String, dynamic> json) => ConveyorReportDetailModel(
        report: json['report'],
        conveyor: json['conveyor'],
        version: json['version'],
        inspector: json['inspector'],
        answers: (json['answers'] as List).map((a) => AnswerModel.fromJson(a)).toList(),
      );
}

class AnswerModel extends Answer {
  AnswerModel({
    required super.answerId,
    required super.sectionName,
    required super.accessoryName,
    required super.optionLabel,
    required super.recommendedAction,
    required super.dimensions,
    required super.evidences,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) => AnswerModel(
        answerId: json['answer_id'],
        sectionName: json['section']['name'],
        accessoryName: json['accesory']['name'],
        optionLabel: json['option']['label'],
        recommendedAction: json['recommended_action'] ?? '',
        dimensions: (json['dimentions'] as num).toDouble(),
        evidences: json['evidences'] ?? [],
      );
}