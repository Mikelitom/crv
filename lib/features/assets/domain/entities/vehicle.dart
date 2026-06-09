class Vehicle {
  final String vehicleId;
  final String plate;
  final String brand;
  final String model;
  final int year;
  final int unit;
  final bool isActive;
  final String typeId;
  final String type;
  final String operationState;
  final String currentLocation;
  final String responsible;
  final int mileage;
  final String? serviceReason;
  final String? phone;
  final DateTime? serviceDate;
  final DateTime? checkoutDate;

  Vehicle({
    required this.vehicleId,
    required this.plate,
    required this.brand,
    required this.model,
    required this.year,
    required this.unit,
    required this.isActive,
    required this.typeId,
    required this.type,
    required this.operationState,
    required this.currentLocation,
    required this.responsible,
    required this.mileage,
    this.serviceReason,
    this.phone,
    this.serviceDate,
    this.checkoutDate,
  });
}
