class Area {
  final String id;
  final String client_id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool is_active;

  Area({
    required this.id,
    required this.client_id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.is_active
  });
}