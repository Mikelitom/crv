import '../../domain/entities/conveyor_report_detail.dart';

// 1. Modelo Principal
class ConveyorReportDetailModel extends ConveyorReportDetail {
  ConveyorReportDetailModel({
    required super.report,
    required super.conveyor,
    required super.version,
    required super.inspector,
    required super.answers,
    required super.rollers,
  });

  factory ConveyorReportDetailModel.fromJson(Map<String, dynamic> json) => 
      ConveyorReportDetailModel(
        report: json['report'] as Map<String, dynamic>? ?? {},
        conveyor: json['conveyor'] as Map<String, dynamic>? ?? {},
        version: json['version'] as Map<String, dynamic>? ?? {},
        inspector: json['inspector'] as Map<String, dynamic>? ?? {},
        answers: (json['answers'] as List?)
                ?.map((a) => AnswerModel.fromJson(a as Map<String, dynamic>))
                .toList() ?? [],
        rollers: (json['rollers'] as List?)
                ?.map((r) => RollerModel.fromJson(r as Map<String, dynamic>))
                .toList() ?? [],
      );
}

class AnswerModel extends Answer {
  final String? customOption; 

  AnswerModel({
    required super.answerId,
    required super.section,
    required super.accessory,
    super.option, // Hacemos super.option opcional
    this.customOption, // Nuevo campo
    required super.recommendedAction,
    required super.dimentions,
    required super.evidences,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) => AnswerModel(
        answerId: json['answer_id'] as String? ?? '',
        section: ReportSection.fromJson(json['section'] as Map<String, dynamic>? ?? {}),
        accessory: Accessory.fromJson(json['accesory'] as Map<String, dynamic>? ?? {}),
        
        // CORRECCIÓN: Manejo seguro de option cuando viene null
        option: json['option'] != null 
            ? ReportOption.fromJson(json['option'] as Map<String, dynamic>) 
            : null,
            
        // NUEVO: Capturamos el custom_option del JSON
        customOption: json['custom_option'] as String?, 
        
        recommendedAction: json['recommended_action'] as String? ?? '',
       dimentions: json['dimentions'] != null 
    ? json['dimentions'].toString(): '',
        evidences: (json['evidences'] as List?)
                ?.map((e) => Evidence.fromJson(e as Map<String, dynamic>))
                .toList() ?? [],
      );
}

class RollerModel extends Roller {
  RollerModel({
    required super.id,
    required super.tableNumber,
    required super.baseNumber,
    required super.isLeft,
    required super.isCenter,
    required super.isRight,
    required super.isImpact,
    required super.isReturn,
    required super.isTriple,
    required super.isSelfAligning,
    required super.observation,
  });

  factory RollerModel.fromJson(Map<String, dynamic> json) => RollerModel(
        id: json['id'] as String? ?? '',
        tableNumber: (json['table_number'] as num?)?.toInt() ?? 0,
        baseNumber: (json['base_number'] as num?)?.toInt() ?? 0,
        isLeft: json['is_left'] ?? false,
        isCenter: json['is_center'] ?? false,
        isRight: json['is_right'] ?? false,
        isImpact: json['is_impact'] ?? false,
        isReturn: json['is_return'] ?? false,
        isTriple: json['is_triple'] ?? false,
        isSelfAligning: json['is_self_aligning'] ?? false,
        observation: json['observation'] as String? ?? '',
      );
}