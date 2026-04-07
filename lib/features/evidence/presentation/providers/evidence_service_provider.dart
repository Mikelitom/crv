import 'package:crv_reprosisa/features/evidence/presentation/providers/upload_file_usecase_provider.dart';
import 'package:crv_reprosisa/features/evidence/presentation/service/evidence_service.dart';

final evidenceServiceProvider = ((ref) {
  return EvidenceService(ref.read(uploadFileUseCaseProvider));
});
