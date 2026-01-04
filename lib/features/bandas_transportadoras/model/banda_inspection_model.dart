class BandaComponentItem {
  final String accessory;
  final List<String> observationOptions; // Para los Radio Buttons
  String? selectedObservation;
  String dimension;
  String actions;

  BandaComponentItem({
    required this.accessory,
    required this.observationOptions,
    this.dimension = "0",
    this.actions = "",
  });
}