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
        report: json['report'] as Map<String, dynamic>? ?? {},
        conveyor: json['conveyor'] as Map<String, dynamic>? ?? {},
        version: json['version'] as Map<String, dynamic>? ?? {},
        inspector: json['inspector'] as Map<String, dynamic>? ?? {},
        answers: (json['answers'] as List?)
                ?.map((a) => AnswerModel.fromJson(a as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class AnswerModel extends Answer {
  AnswerModel({
    required super.answerId,
    required super.section,
    required super.accessory,
    required super.option,
    required super.recommendedAction,
    required super.dimensions,
    required super.evidences,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) => AnswerModel(
        answerId: json['answer_id'] as String? ?? '',
        section: ReportSection.fromJson(json['section'] as Map<String, dynamic>? ?? {}),
        accessory: Accessory.fromJson(json['accesory'] as Map<String, dynamic>? ?? {}),
        option: ReportOption.fromJson(json['option'] as Map<String, dynamic>? ?? {}),
        recommendedAction: json['recommended_action'] as String? ?? '',
        dimensions: (json['dimentions'] as num?)?.toDouble() ?? 0.0,
        evidences: (json['evidences'] as List<dynamic>?)
                ?.map((e) => Evidence.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}