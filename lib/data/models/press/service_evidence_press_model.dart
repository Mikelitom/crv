import 'package:crv_reprosisa/domain/entities/press/service_evidence_press.dart';

class ServiceEvidencePressModel extends ServiceEvidencePress {

  ServiceEvidencePressModel({
    required super.id,
    required super.user_id,
    required super.service_id,
    required super.bucket_name,
    required super.file_path,
    required super.file_name,
    required super.mime_type,
    required super.size_bytes,
    required super.public_url,
    required super.createdAt,
  });
  factory ServiceEvidencePressModel.fromJson(Map<String, dynamic> json) {
    return ServiceEvidencePressModel(
      id: json['id'],
      user_id: json['user_id'],
      service_id: json['service_id'],
      bucket_name: json['bucket_name'],
      file_path: json['file_path'],
      file_name: json['file_name'],
      mime_type: json['mime_type'],
      size_bytes: json['size_bytes'],
      public_url: json['public_url'],
      createdAt: DateTime.parse(json['created_at']),
    );

  }
}