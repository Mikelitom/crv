class VehicleTypesModel {
  final String id;
  final String code;
  final String name;
  final String? description;
  final DateTime createdAt;
  final bool is_active;

  VehicleTypesModel({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.createdAt,
    required this.is_active,

  });
}