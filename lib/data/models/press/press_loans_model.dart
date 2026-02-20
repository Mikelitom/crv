import 'package:crv_reprosisa/domain/entities/press/press_loans.dart';

class PressLoansModel extends PressLoans{
  PressLoansModel({
    required super.id,
    required super.report_id,
    required super.press_id,
    required super.reponsible_id,
    required super.area,
    required super.solicitants_name,
    super.observations,
    required super.loan_date,
    super.expected_return_date,
    super.actual_return_date,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active,
  });

  factory PressLoansModel.fromJson(Map<String, dynamic> json) {
    return PressLoansModel(
      id: json['id'],
      report_id: json['report_id'],
      press_id: json['press_id'],
      reponsible_id: json['responsible_id'],
      area: json['area'],
      solicitants_name: json['solicitants_name'],
      observations: json['observations'],
      loan_date: DateTime.parse(json['loand_date']),
      expected_return_date: DateTime.parse(json['expected_return_date']),
      actual_return_date: DateTime.parse(json['actual_return_date']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],
    );
  }
}