class CreateVehicleParams {

  final String typeId;
  final String brand;
  final String model;
  final String year;
  final String licensePlate;

  CreateVehicleParams ({
    
    required this.typeId,
    required this.brand,
    required this.model,
    required this.year,
    required this.licensePlate,
  });
}