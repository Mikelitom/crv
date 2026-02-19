class ServiceEvidenceVehicle{
  final String id;
  final String user_id;
  final String service_id;
  final String bucket_name;
  final String file_path;
  final String file_name;
  final String mime_type;
  final String size_bytes;
  final String public_url;
  final DateTime createdAt;

  ServiceEvidenceVehicle({
    required this.id,
    required this.user_id,
    required this.service_id,
    required this.bucket_name,
    required this.file_path,
    required this.file_name,
    required this.mime_type,
    required this.size_bytes,
    required this.public_url,
    required this.createdAt,
  });
}