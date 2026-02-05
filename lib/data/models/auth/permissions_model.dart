class PermissionsModel{
  final String id;
  final String code;
  final String? description;
  final DateTime createdAt;

  PermissionsModel({
    required this.id,
    required this.code,
    this.description,
    required this.createdAt, 
  });

}