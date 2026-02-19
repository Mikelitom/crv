class InspectionItemModel {
  final String description;
  int? status; // 0: Buena, 1: Mala, 2: Reposición, 3: Reparación
  String observations;

  InspectionItemModel({
    required this.description,
    this.status,
    this.observations = "",
  });
}