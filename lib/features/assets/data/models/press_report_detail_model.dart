import '../../domain/entities/press_report_detail_entity.dart';
import 'press_answer_model.dart';

class PressReportDetailModel extends PressReportDetailEntity {
  PressReportDetailModel({
    required super.report,
    required super.press,
    required super.responsibleName,
    required super.answers,
  });

  factory PressReportDetailModel.fromJson(Map<String, dynamic> json) {
    return PressReportDetailModel(
      report: json['report'] ?? {},
      press: json['press'] ?? {},
      responsibleName: json['responsible']?['name'] ?? '',
      answers: (json['answers'] as List<dynamic>?)
          ?.map((i) => PressAnswerModel.fromJson(i))
          .toList() ?? [],
    );
  }
}