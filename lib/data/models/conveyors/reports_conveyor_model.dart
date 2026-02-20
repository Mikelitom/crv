import 'package:crv_reprosisa/domain/entities/conveyors/reports_conveyor.dart';

class ReportsConveyorModel extends ReportsConveyor{

  ReportsConveyorModel({
    required super.id,
    required super.conveyor_id,
    required super.inspection_date,
    required super.inspector_id,
    super.conveyor_responsible,
    super.recommended_balt,
    super.material,
    super.granulometry,
    super.present_to,
    required super.state,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active,
    required super.folio,
  });
    factory ReportsConveyorModel.fromJson(Map<String, dynamic> json) {
    return ReportsConveyorModel(
      id: json['id'],
      conveyor_id: json['conveyor_id'],
      inspection_date: DateTime.parse(json['inspection_date']),
      inspector_id: json['inspector_id'],
      conveyor_responsible: json['conveyor_responsible'],
      recommended_balt: json['recommended_balt'],
      material: json['material'],
      granulometry: json['granulometry'],
      present_to: json['present_to'],
      state: json['state'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],
      folio: json['folio'],

    );
  }
}