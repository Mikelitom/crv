class SectionsConveyorModel {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool? is_active;

   SectionsConveyorModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.is_active,
   });
}