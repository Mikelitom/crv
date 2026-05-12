class Press {
  final String id;
  final String type;
  final String model;
  final String voltz;
  final String serie;
  final String size;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final List<Map>? mines; 

  Press({
    required this.id,
    required this.type,
    required this.model,
    required this.voltz,
    required this.serie,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    this.mines,
  });
}
