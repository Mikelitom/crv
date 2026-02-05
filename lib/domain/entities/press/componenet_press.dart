class ComponenetPress {
  final String id;
  final String name;
  final String meassure_unit;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool is_active;

  ComponenetPress({
    required this.id,
    required this.name,
    required this.meassure_unit,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.is_active,
  });
}