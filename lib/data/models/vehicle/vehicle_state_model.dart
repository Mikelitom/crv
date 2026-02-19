class VehicleStateModel {
  final String id;
  final String vehicle_id;
  final String state;
  final String responsible_id;
  final String location;
  final DateTime check_out;
  final DateTime check_in;
  final String mileage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool is_active;

  VehicleStateModel({
    required this.id,
    required this.vehicle_id,
    required this.state,
    required this.responsible_id,
    required this.location,
    required this.check_out,
    required this.check_in,
    required this.mileage,
    required this.createdAt,
    required this.updatedAt,
    required this.is_active

  });
}
