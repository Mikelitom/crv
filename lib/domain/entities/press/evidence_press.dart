class EvidencePress {
  final String id;
  final String answer_id;
  final String file_url;
  final String file_type;
  final String mime_tupe;
  final String? file_size;
  final DateTime createdAt;

  EvidencePress({
    required this.id,
    required this.answer_id,
    required this.file_url,
    required this.file_type,
    required this.mime_tupe,
    this.file_size,
    required this.createdAt,
  });
}