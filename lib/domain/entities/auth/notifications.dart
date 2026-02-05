class Notifications {
  final String id;
  final String user_id;
  final String type;
  final String title;
  final String message;
  final String? entity_type;
  final String? entity_id;
  final bool is_read;
  final DateTime createdAt;

  Notifications({
    required this.id,
    required this.user_id,
    required this.type,
    required this.title,
    required this.message,
    this.entity_type,
    this.entity_id,
    required this.is_read,
    required this.createdAt,

  });
}