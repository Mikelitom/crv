class AccesoriesConveyor {
  final String id;
  final String section_id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool is_active;
  final String? description;
  final String name;

  AccesoriesConveyor({
    required this.id,
    required this.section_id,
    required this.createdAt,
    required this.updatedAt,
    required this.is_active,
    this.description,
    required this.name,
  });
}