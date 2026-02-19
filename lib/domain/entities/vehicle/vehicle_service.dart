class VehicleService {
  final String id;
  final String vehicle_id;
  final String description;
  final String observation;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool is_active; 

  VehicleService({
    required this.id,
    required this.vehicle_id,
    required this.description,
    required this.observation,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.is_active,
  });
}