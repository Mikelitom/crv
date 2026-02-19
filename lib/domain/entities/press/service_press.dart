class ServicePress {
  final String id;
  final String press_id;
  final String description;
  final String observation;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool is_active; 

  ServicePress({
    required this.id,
    required this.press_id,
    required this.description,
    required this.observation,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.is_active,
  });
}