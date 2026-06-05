import '../../domain/entities/press_history.dart';

class PressHistoryModel extends PressHistory {
  PressHistoryModel({
    required super.pressId, required super.serie, required super.model,
    required super.type, required super.size, required super.voltz,
    required super.reportId, required super.folio, required super.state,
    required super.inspectionDate, required super.area, required super.responsibleName,
    required super.versionId, required super.versionNumber, required super.isCurrent,
    required super.answersCount, required super.evidencesCount,
  });

  factory PressHistoryModel.fromJson(Map<String, dynamic> json) {
    return PressHistoryModel(
      pressId: json['press_id'] ?? '',
      serie: json['serie'] ?? '',
      model: json['model'] ?? '',
      type: json['type'] ?? '',
      size: json['size'] ?? '',
      voltz: json['voltz'] ?? '',
      reportId: json['report_id'] ?? '',
      folio: json['folio'] ?? '',
      state: json['state'] ?? '',
      inspectionDate: DateTime.tryParse(json['inspection_date'] ?? '') ?? DateTime.now(),
      area: json['area'] ?? '',
      responsibleName: json['responsible_name'] ?? '',
      versionId: json['version_id'] ?? '',
      versionNumber: json['version_number'] ?? 0,
      isCurrent: json['is_current'] ?? false,
      answersCount: json['answers_count'] ?? 0,
      evidencesCount: json['evidences_count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serie': serie,
      'modelo': model,
      'tipo': type,
      'volts': voltz,
      'fecha': inspectionDate.toIso8601String(),
      'area': area,
      'folio': folio,
      'items': [], // Aquí irían tus items de inspección
    };
  }
}