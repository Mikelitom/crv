class PressesModel {
  final String id;
  final String type;
  final String model;
  final String voltz;
  final String serie;
  final String size;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool is_active;

  PressesModel({
    required this.id,
    required this.type,
    required this.model,
    required this.voltz,
    required this.serie,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
    required this.is_active,
  });
}