class CreateVehicleParams {
  final String typeId;
  final String brand;
  final String model;
  final int unit;
  final int year;
  final String plate;

  CreateVehicleParams({
    required this.typeId,
    required this.brand,
    required this.model,
    required this.unit,
    required this.year,
    required this.plate,
  });
}
