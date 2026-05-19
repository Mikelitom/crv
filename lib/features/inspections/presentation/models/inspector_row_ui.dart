class InspectionRowUI {
  final String id;
  final String reportType;
  final String title;
  final String description;
  final String folio;
  final String state;
  final int versionNumber;
  final String userName;
  final String date;

  // Constructor intacto
  InspectionRowUI({
    required this.id,
    required this.reportType,
    required this.title,
    required this.description,
    required this.folio,
    required this.state,
    required this.versionNumber,
    required this.userName,
    required this.date,
  });

  String get translatedReportType {
    switch (reportType.toUpperCase()) {
      case 'PRESS': return 'PRENSA';
      case 'CONVEYOR': return 'BANDA';
      case 'VEHICLE': return 'VEHÍCULO';
      default: return reportType;
    }
  }

  String get translatedState {
    switch (state.toUpperCase()) {
      case 'IN_PROGRESS': return 'EN PROGRESO';
      case 'COMPLETED': return 'COMPLETADO';
      default: return state;
    }
  }

  factory InspectionRowUI.fromJson(Map<String, dynamic> json) {
    final String titleText = json['title'] ?? '';
    
    // 🔥 Lógica para extraer la versión del texto si viene pegada en el título (ej: "Reporte Banda v2")
    int extractedVersion = 0;
    final match = RegExp(r'v(\d+)$', caseSensitive: false).firstMatch(titleText);
    if (match != null) {
      extractedVersion = int.tryParse(match.group(1) ?? '0') ?? 0;
    }

    // Leemos el version_number que venga del JSON. Si viene null o no es válido, usa la extraída del string.
    int finalVersion = 0;
    if (json['version_number'] is int) {
      finalVersion = json['version_number'];
    } else if (json['version_number'] != null) {
      finalVersion = int.tryParse(json['version_number'].toString()) ?? extractedVersion;
    } else {
      finalVersion = extractedVersion; // Resguardo seguro
    }

    return InspectionRowUI(
      id: json['report_id'] ?? '',
      reportType: json['report_type'] ?? '',
      title: titleText,
      description: json['description'] ?? '',
      folio: json['folio'] ?? '',
      state: json['state'] ?? '',
      versionNumber: finalVersion, // 🔥 Ahora asigna la versión real calculada
      userName: json['user_name'] ?? '',
      date: json['inspection_date']?.toString().split('T')[0] ?? '',
    );
  }
}