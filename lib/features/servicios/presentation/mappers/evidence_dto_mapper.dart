import 'package:crv_reprosisa/features/evidence/presentation/dto/evidence_dto.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/service_evidence.dart';

extension EvidenceDtoMapper on EvidenceDto {
  ServiceEvidence toServiceEvidence() {
    return ServiceEvidence(
      filePath: filePath,
      fileName: filePath.split('/').last,
      mimeType: mimeType,
      sizeBytes: int.parse(fileSize),
    );
  }
}