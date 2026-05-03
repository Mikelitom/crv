import '../../domain/entities/press_report_entity.dart';

class PressReportModel extends PressReportEntity {
  PressReportModel({
    required super.pressId,
    required super.inspectionDate,
    required super.area,
    required super.folio,
    required List<PressAnswerModel> super.answers,
    super.loan,
  });

  Map<String, dynamic> toJson() => {
        "press_id": pressId,
        "inspection_date": inspectionDate.toIso8601String(),
        "area": area,
        "folio": folio,
        "answers": answers.map((x) => (x as PressAnswerModel).toJson()).toList(),
        "loan": loan != null ? {
          "area_id": loan!.areaId,
          "loan_date": loan!.loanDate.toIso8601String(),
          "solicitants_name": loan!.solicitantsName,
          "observations": loan!.observations,
        } : null,
      };
}

class PressAnswerModel extends PressAnswerEntity {
  final List<Map<String, String>> uploadedEvidences;

  PressAnswerModel({
    required super.componentId,
    required super.quantity,
    required super.status,
    required super.observation,
    this.uploadedEvidences = const [],
  });

  Map<String, dynamic> toJson() => {
        "component_id": componentId,
        "quantity": quantity,
        "status": status,
        "observation": observation,
        "evidences": uploadedEvidences, 
      };
}