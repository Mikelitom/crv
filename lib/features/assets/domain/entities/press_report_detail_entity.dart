import 'press_answer_entity.dart';

class PressReportDetailEntity {
  final Map<String, dynamic> report;
  final Map<String, dynamic> press;
  final String responsibleName;
  final List<PressAnswerEntity> answers;

  PressReportDetailEntity({
    required this.report, 
    required this.press, 
    required this.responsibleName, 
    required this.answers
  });
}