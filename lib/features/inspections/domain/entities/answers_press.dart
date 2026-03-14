class AnswersPress {
  final String id;
  final String reportId;
  final String componentId;
  final double quantity;
  final String status;
  final String? observation;
  final DateTime createdAt;

  AnswersPress({
    required this.id,
    required this.reportId,
    required this.componentId,
    required this.quantity,
    required this.status,
    this.observation,
    required this.createdAt,
  });
}

