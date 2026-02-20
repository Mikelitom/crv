import 'package:crv_reprosisa/domain/entities/conveyors/evidence_conveyor.dart';

class EvidenceConveyorModel extends EvidenceConveyor{
  
  EvidenceConveyorModel({
    required this.id,
    required this.answer_id,
    required this.file_url,
    required this.file_type,
    required this.mime_type,
    this.file_size,
    required this.createdAt,
  });


}