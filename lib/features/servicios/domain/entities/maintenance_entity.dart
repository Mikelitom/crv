class Maintenance {
  final String id;
  final String vehicleId;
  final String orderNumber;
  final String description;
  final DateTime date;
  final String status;

  Maintenance({
    required this.id,
    required this.vehicleId,
    required this.orderNumber,
    required this.description,
    required this.date,
    required this.status,
  });
}