import 'dart:convert';

class ReportStatModel {
  final String reportType;
  final DateTime inspectionDate;

  ReportStatModel({
    required this.reportType,
    required this.inspectionDate,
  });

  factory ReportStatModel.fromJson(Map<String, dynamic> json) {
    return ReportStatModel(
      reportType: json['report_type'] ?? '',
      inspectionDate: DateTime.parse(json['inspection_date']),
    );
  }

  static List<ReportStatModel> listFromJson(dynamic str) {
    final data = str is String ? json.decode(str) : str;
    return List<ReportStatModel>.from(data.map((x) => ReportStatModel.fromJson(x)));
  }
}