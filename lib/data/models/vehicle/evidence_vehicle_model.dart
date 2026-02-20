import 'package:crv_reprosisa/domain/entities/vehicle/evidence_vehicle.dart';

class EvidenceVehicleModel extends EvidenceVehicle{

  EvidenceVehicleModel({
    required super.id,
    required super.answer_id,
    required super.file_url,
    required super.file_type,
    required super.mime_type,
    super.file_size,
    required super.createdAt,
});
factory EvidenceVehicleModel.fromJson(Map<String, dynamic> json) {
    return EvidenceVehicleModel(
      id: json['id'],
      answer_id: json['answer_id'],
      file_url: json['file_url'],
      file_type: json['file_type'],
      mime_type: json['mime_type'],
      file_size: json['file_size'],
      createdAt: DateTime.parse(json['created_at']),
    );
}
}
