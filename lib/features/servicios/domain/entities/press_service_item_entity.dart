class PressServiceItemEntity {
  final String id;
  final String componentName;
  final String description;
  final String status;
  final int quantity;
  final String measureUnit;
  final String observation;

  const PressServiceItemEntity({
    required this.id,
    required this.componentName,
    required this.description,
    required this.status,
    required this.quantity,
    required this.measureUnit,
    required this.observation,
  });
}