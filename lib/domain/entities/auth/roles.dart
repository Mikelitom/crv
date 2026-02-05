class Roles{
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;

  Roles({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt, 
  });

}