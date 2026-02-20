import 'package:crv_reprosisa/domain/entities/conveyors/evidence_conveyor.dart';

class EvidenceConveyorModel extends EvidenceConveyor{
  
  EvidenceConveyorModel({
    required super.id,
    required super.answer_id,
    required super.file_url,
    required super.file_type,
    required super.mime_type,
    super.file_size,
    required super.createdAt,
  });

factory EvidenceConveyorModel.fromJson(Map<String, dynamic> json) {
    return EvidenceConveyorModel(
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