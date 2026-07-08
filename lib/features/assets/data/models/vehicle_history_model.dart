import '../../domain/entities/vehicle_history.dart';

class VehicleHistoryModel extends VehicleHistory {
  VehicleHistoryModel({
    required super.vehicleId,
    required super.brand,
    required super.model,
    required super.year,
    required super.plate,
    required super.unit,
    required super.vehicleType,
    required super.reportId,
    required super.folio,
    required super.state,
    required super.inspectionDate,
    required super.mileage,
    required super.requiresService,
    required super.responsibleId,
    required super.responsibleName,
    required super.versionId,
    required super.versionNumber,
    required super.isCurrent,
    required super.answersCount,
    required super.evidencesCount,
    required super.generalNotes,
    required super.evidencePaths,
  });

  /// Getter centralizado para la traducción de estados
  String get translatedState {
    switch (state.toUpperCase()) {
      case 'COMPLETED': return 'COMPLETADO';
      case 'IN_PROGRESS': return 'EN PROCESO';
      case 'PENDING': return 'PENDIENTE';
      case 'AVAILABLE': return 'DISPONIBLE'; // Corregido: Available
      case 'IN_SERVICE': return 'EN SERVICIO';
      default: return state;
    }
  }

  factory VehicleHistoryModel.fromJson(Map<String, dynamic> json) {
    // 1. Limpieza de notas
    final String notes = json['general_notes']?.toString() ?? 
                         json['report']?['general_notes']?.toString() ?? 
                         '';

    // 2. Manejo flexible de evidencias
    final List<String> paths = (json['evidences'] as List<dynamic>?)?.map((e) {
      if (e is Map) {
        return e['signed_url']?.toString() ?? e['file_path']?.toString() ?? '';
      }
      return e.toString();
    }).where((path) => path.isNotEmpty).toList() ?? [];

    return VehicleHistoryModel(
      vehicleId: json['vehicle_id']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      year: json['year'] is int ? json['year'] : int.tryParse(json['year']?.toString() ?? '0') ?? 0,
      plate: json['plate']?.toString() ?? '',
      unit: json['unit'] is int ? json['unit'] : int.tryParse(json['unit']?.toString() ?? '0') ?? 0,
      vehicleType: json['vehicle_type']?.toString() ?? '',
      reportId: json['report_id']?.toString() ?? '',
      folio: json['folio']?.toString() ?? '',
      state: json['state']?.toString() ?? 'PENDING',
      inspectionDate: DateTime.tryParse(json['inspection_date']?.toString() ?? '') ?? DateTime.now(),
      mileage: json['mileage'] is int ? json['mileage'] : int.tryParse(json['mileage']?.toString() ?? '0') ?? 0,
      requiresService: json['requires_service'] == true || json['requires_service'].toString() == 'true',
      responsibleId: json['responsible_id']?.toString() ?? '',
      responsibleName: json['responsible_name']?.toString() ?? '',
      versionId: json['version_id']?.toString() ?? '',
      versionNumber: json['version_number'] is int ? json['version_number'] : int.tryParse(json['version_number']?.toString() ?? '0') ?? 0,
      isCurrent: json['is_current'] == true || json['is_current'].toString() == 'true',
      answersCount: json['answers_count'] is int ? json['answers_count'] : 0,
      evidencesCount: json['evidences_count'] is int ? json['evidences_count'] : 0,
      generalNotes: notes, 
      evidencePaths: paths, 
    );
  }

  Map<String, dynamic> toJson() => {
        "vehicle_id": vehicleId,
        "folio": folio,
        "state": state,
        "general_notes": generalNotes,
        "mileage": mileage,
        "inspection_date": inspectionDate.toIso8601String(),
        "responsible_name": responsibleName,
        "evidences_count": evidencesCount,
        "evidences": evidencePaths,
      };
}