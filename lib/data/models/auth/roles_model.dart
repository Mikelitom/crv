class RolesModel{
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;

  RolesModel({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt, 
  });

}