class ClientHistory {
  final String clientId;
  final String clientName;
  final String clientCompany;
  final String mineId;
  final String mineName;
  final String areaId;
  final String areaName;
  final String conveyorId;
  final String conveyorName;
  final String reportId;
  final String folio;
  final String state;
  final DateTime inspectionDate;
  final String material;
  final String granulometry;
  final String inspectorId;
  final String inspectorName;
  final String versionId;
  final int versionNumber;
  final bool isCurrent;
  final int answersCount;
  final int evidencesCount;
  final String? comment; // <--- 1. PROPIEDAD AGREGADA

  ClientHistory({
    required this.clientId,
    required this.clientName,
    required this.clientCompany,
    required this.mineId,
    required this.mineName,
    required this.areaId,
    required this.areaName,
    required this.conveyorId,
    required this.conveyorName,
    required this.reportId,
    required this.folio,
    required this.state,
    required this.inspectionDate,
    required this.material,
    required this.granulometry,
    required this.inspectorId,
    required this.inspectorName,
    required this.versionId,
    required this.versionNumber,
    required this.isCurrent,
    required this.answersCount,
    required this.evidencesCount,
    this.comment, // <--- 2. CONSTRUCTOR AGREGADO
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientHistory &&
          runtimeType == other.runtimeType &&
          versionId == other.versionId;

  @override
  int get hashCode => versionId.hashCode;
  ClientHistory copyWith({
    String? clientId,
    String? clientName,
    String? clientCompany,
    String? mineId,
    String? mineName,
    String? areaId,
    String? areaName,
    String? conveyorId,
    String? conveyorName,
    String? reportId,
    String? folio,
    String? state,
    DateTime? inspectionDate,
    String? material,
    String? granulometry,
    String? inspectorId,
    String? inspectorName,
    String? versionId,
    int? versionNumber,
    bool? isCurrent,
    int? answersCount,
    int? evidencesCount,
    String? comment, // <--- 3. AGREGADO A COPYWITH
  }) {
    return ClientHistory(
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientCompany: clientCompany ?? this.clientCompany,
      mineId: mineId ?? this.mineId,
      mineName: mineName ?? this.mineName,
      areaId: areaId ?? this.areaId,
      areaName: areaName ?? this.areaName,
      conveyorId: conveyorId ?? this.conveyorId,
      conveyorName: conveyorName ?? this.conveyorName,
      reportId: reportId ?? this.reportId,
      folio: folio ?? this.folio,
      state: state ?? this.state,
      inspectionDate: inspectionDate ?? this.inspectionDate,
      material: material ?? this.material,
      granulometry: granulometry ?? this.granulometry,
      inspectorId: inspectorId ?? this.inspectorId,
      inspectorName: inspectorName ?? this.inspectorName,
      versionId: versionId ?? this.versionId,
      versionNumber: versionNumber ?? this.versionNumber,
      isCurrent: isCurrent ?? this.isCurrent,
      answersCount: answersCount ?? this.answersCount,
      evidencesCount: evidencesCount ?? this.evidencesCount,
      comment: comment ?? this.comment, // <--- 4. ASIGNACIÓN EN COPYWITH
    );
  }
}