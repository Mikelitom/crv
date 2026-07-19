class InspectionRowUI {
  final String id;
  final String versionId;
  final String reportType;
  final String title;
  final String description;
  final String folio;
  final String state;
  final int versionNumber;
  final String userName;
  final String date;
  // Nuevos campos
  final String? reviewNotes;
  final String? reviewAnswer;
  final List<InspectionRowUI>? allVersions;

  InspectionRowUI({
    required this.id,
    required this.versionId,
    required this.reportType,
    required this.title,
    required this.description,
    required this.folio,
    required this.state,
    required this.versionNumber,
    required this.userName,
    required this.date,
    this.reviewNotes,
    this.reviewAnswer,
    this.allVersions,
  });

  InspectionRowUI copyWith({
    List<InspectionRowUI>? allVersions,
    String? reviewNotes,
    String? reviewAnswer,
  }) {
    return InspectionRowUI(
      id: id,
      versionId: versionId,
      reportType: reportType,
      title: title,
      description: description,
      folio: folio,
      state: state,
      versionNumber: versionNumber,
      userName: userName,
      date: date,
      reviewNotes: reviewNotes ?? this.reviewNotes,
      reviewAnswer: reviewAnswer ?? this.reviewAnswer,
      allVersions: allVersions ?? this.allVersions,
    );
  }

  String get translatedReportType {
    switch (reportType.toUpperCase()) {
      case 'PRESS':
        return 'PRENSA';
      case 'CONVEYOR':
        return 'BANDA';
      case 'VEHICLE':
        return 'VEHÍCULO';
      default:
        return reportType;
    }
  }

  String get translatedState {
    switch (state.toUpperCase()) {
      case 'IN_PROGRESS':
        return 'EN PROGRESO';
      case 'COMPLETED':
        return 'COMPLETADO';
      case 'IN_REVISION':
        return 'EN REVISION';
      case 'RETURNED':
        return 'DEVUELTO';
      default:
        return state;
    }
  }

  factory InspectionRowUI.fromJson(Map<String, dynamic> json) {
    final String titleText = json['title'] ?? '';

    int extractedVersion = 0;
    final match = RegExp(
      r'v(\d+)$',
      caseSensitive: false,
    ).firstMatch(titleText);
    if (match != null) {
      extractedVersion = int.tryParse(match.group(1) ?? '0') ?? 0;
    }

    int finalVersion = 0;
    if (json['version_number'] is int) {
      finalVersion = json['version_number'];
    } else if (json['version_number'] != null) {
      finalVersion =
          int.tryParse(json['version_number'].toString()) ?? extractedVersion;
    } else {
      finalVersion = extractedVersion;
    }

    return InspectionRowUI(
      id: json['report_id'] ?? '',
      versionId:
          json['version_id']?.toString() ?? json['report_id']?.toString() ?? '',
      reportType: json['report_type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      folio: json['folio'] ?? '',
      state: json['state'] ?? '',
      versionNumber: finalVersion, // Tu lógica de versión
      userName: json['user_name'] ?? '',
      date: json['inspection_date']?.toString().split('T')[0] ?? '',
      // Mapeo de las nuevas columnas del SQL
      reviewNotes: json['review_notes'],
      reviewAnswer: json['review_answer'],
    );
  }
}
