class InspectionItemModel {
  final String description;
  int? status; // 0: Buena, 1: Mala, 2: Reposición, 3: Reparación, 4: N/A
  String observations;
  String? imagePath; // Para la miniatura de la evidencia

  InspectionItemModel({
    required this.description,
    this.status,
    this.observations = "",
    this.imagePath,
  });
}