class VehicleHistory {
  final String vehicleId;
  final String brand;
  final String model;
  final int year;
  final String plate;
  final int unit;
  final String vehicleType;
  final String reportId;
  final String folio;
  final String state;
  final DateTime inspectionDate;
  final int mileage;
  final bool requiresService;
  final String responsibleId;
  final String responsibleName;
  final String versionId;
  final int versionNumber;
  final bool isCurrent;
  final int answersCount;
  final int evidencesCount;
  final String generalNotes;
  final List<String> evidencePaths;

  VehicleHistory({
    required this.vehicleId,
    required this.brand,
    required this.model,
    required this.year,
    required this.plate,
    required this.unit,
    required this.vehicleType,
    required this.reportId,
    required this.folio,
    required this.state,
    required this.inspectionDate,
    required this.mileage,
    required this.requiresService,
    required this.responsibleId,
    required this.responsibleName,
    required this.versionId,
    required this.versionNumber,
    required this.isCurrent,
    required this.answersCount,
    required this.evidencesCount,
    required this.generalNotes,
    required this.evidencePaths,
  });

  /// Método para convertir la entidad a JSON. 
  /// Esto permite que todas las subclases (como VehicleHistoryModel) 
  /// compartan esta estructura para la generación de PDFs.
  Map<String, dynamic> toJson() {
    return {
      "vehicle_id": vehicleId,
      "brand": brand,
      "model": model,
      "year": year,
      "plate": plate,
      "unit": unit,
      "vehicle_type": vehicleType,
      "report_id": reportId,
      "folio": folio,
      "state": state,
      "inspection_date": inspectionDate.toIso8601String(),
      "mileage": mileage,
      "requires_service": requiresService,
      "responsible_id": responsibleId,
      "responsible_name": responsibleName,
      "version_id": versionId,
      "version_number": versionNumber,
      "is_current": isCurrent,
      "answers_count": answersCount,
      "evidences_count": evidencesCount,
      "general_notes": generalNotes,
      "evidences": evidencePaths,
    };
  }
}