import 'dart:io';

class CreateVehicleParams {
  final String typeId;
  final String brand;
  final String model;
  final int unit;
  final int year;
  final String plate;
  final File? image;

  CreateVehicleParams({
    required this.typeId,
    required this.brand,
    required this.model,
    required this.unit,
    required this.year,
    required this.plate,
    this.image,
  });
}
