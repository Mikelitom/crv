class VehicleMonitor {
  final String id;
  final String model;
  final String status;
  final String responsable;
  final String schedule; // Salida / Regreso
  final String odometer;
  final String location; // Nueva columna principal
  final bool hasAlert;

  VehicleMonitor({
    required this.id,
    required this.model,
    required this.status,
    required this.responsable,
    required this.schedule,
    required this.odometer,
    required this.location,
    this.hasAlert = false,
  });
}