class CreateServiceOrderEntity {
  final String vehicleId;
  final String description;
  final String observation;
  final List<String> serviceItems;

  const CreateServiceOrderEntity({
    required this.vehicleId,
    required this.description,
    required this.observation,
    required this.serviceItems,
  });
}