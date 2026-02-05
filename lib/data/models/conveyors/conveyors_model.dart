class ConveyorsModel{
  final String id;
  final String area_id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool is_active;


  ConveyorsModel({
    required this.id,
    required this.area_id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.is_active,
  });

}