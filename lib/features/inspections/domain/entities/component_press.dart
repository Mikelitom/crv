class ComponentPress {
  final String id;
  final String name;
  final String measureUnit;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  ComponentPress({
    required this.id,
    required this.name,
    required this.measureUnit,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });
}

