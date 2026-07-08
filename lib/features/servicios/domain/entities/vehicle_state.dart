abstract class VehicleStateEntity {
  final String id;
  final DateTime checkOut;
  final DateTime? checkIn;

  VehicleStateEntity({required this.id, required this.checkOut, this.checkIn});
}