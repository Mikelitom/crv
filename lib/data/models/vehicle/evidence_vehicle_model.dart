class EvidenceVehicleModel {
  final String id;
  final String answer_id;
  final String file_url;
  final String file_type;
  final String mime_type;
  final String? file_size;
  final DateTime createdAt;

  EvidenceVehicleModel({
    required this.id,
    required this.answer_id,
    required this.file_url,
    required this.file_type,
    required this.mime_type,
    this.file_size,
    required this.createdAt,
});
}
