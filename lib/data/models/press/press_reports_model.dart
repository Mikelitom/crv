import 'package:crv_reprosisa/domain/entities/press/press_reports.dart';

class PressReportsModel extends PressReports {

  PressReportsModel({
    required super.id,
    required super.press_id,
    required super.reponsible_id,
    required super.inspection_date,
    required super.area,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active,
    required super. state,
    required super.folio,
  });
  factory PressReportsModel.fromJson(Map<String, dynamic> json) {
    return PressReportsModel(
      id: json['id'],
      press_id: json['press_id'],
      reponsible_id: json['responsible_id'],
      inspection_date: DateTime.parse(json['inspection_date']),
      area: json['area'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],
      folio: json['folio'],
      state: json['state'],

    );
  }
}