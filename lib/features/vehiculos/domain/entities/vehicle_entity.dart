class Vehicle {
  final String id;
  final String typeId;
  final String brand;
  final String model;
  final int unit;
  final int year;
  final String plate;
 
  Vehicle({
    required this.id,
    required this.typeId,
    required this.brand,
    required this.model,
    required this.unit,
    required this.year,
    required this.plate,
    
  });

   factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id']?.toString() ?? '',
      typeId: json['type_id']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      unit: json['unit'],
      year: json['year'],
      plate: json['plate']?.toString() ?? '',
      
    );
  }
}
