class Permissions{
  final String id;
  final String code;
  final String? description;
  final DateTime createdAt;

  Permissions({
    required this.id,
    required this.code,
    this.description,
    required this.createdAt, 
  });

}