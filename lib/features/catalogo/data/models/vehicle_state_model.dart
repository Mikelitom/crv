class VehicleStateModel {
  final String id;
  final String plate;        
  final String responsibleName;       
  final String? location;
  final DateTime? checkin;
  final DateTime? checkout;
 final int? mileage;
  final bool isActive;

  VehicleStateModel({
    required this.id,
    required this.plate,
    required this.responsibleName,
    this.location,
    this.checkin,
    this.checkout,
    this.mileage,
    required this.isActive,
  });

  factory VehicleStateModel.fromJson(Map<String, dynamic> json) {
    return VehicleStateModel(
      id: json['id']?.toString() ?? '',
      plate: json['plate']?.toString() ?? json['vehicle_id']?.toString() ?? 'S/P', 
      responsibleName: json['responsible_name'],
      location: json['location']?.toString(),
      checkin: json['check_in'] != null ? DateTime.tryParse(json['checkin'].toString()) : null,
      checkout: json['check_out'] != null ? DateTime.tryParse(json['checkout'].toString()) : null,
      mileage: int.tryParse(json['mileage']?.toString() ?? '0') ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }
}