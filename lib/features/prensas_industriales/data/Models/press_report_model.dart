import '../../domain/entities/press_report_entity.dart';

class PressReportModel extends PressReportEntity {
  PressReportModel({
    required super.pressId,
    required super.responsibleId,
    required super.inspectionDate,
    required super.area,
    required super.folio,
    required List<PressAnswerModel> super.answers,
  });

  Map<String, dynamic> toJson() => {
    "press_id": pressId,
    "responsible_id": responsibleId,
    "inspection_date": inspectionDate.toIso8601String(),
    "area": area,
    "folio": folio,
    "answers": answers.map((x) => (x as PressAnswerModel).toJson()).toList(),
  };
}

class PressAnswerModel extends PressAnswerEntity {
  PressAnswerModel({
    required super.componentId,
    required super.quantity,
    required super.status,
    required super.observation,
  });

  Map<String, dynamic> toJson() => {
    "component_id": componentId,
    "quantity": quantity,
    "status": status,
    "observation": observation,
    "evidences": [], // Se puede expandir para fotos
  };
}