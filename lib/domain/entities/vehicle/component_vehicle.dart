class ComponentVehicle {
  final String id;
  final String section_id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool is_active;

  ComponentVehicle({
    required this.id,
    required this.section_id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.is_active,
  });
}