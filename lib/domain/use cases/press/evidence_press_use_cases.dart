import '../base_use_case.dart';
import '../../entities/press/evidence_press.dart';
import '../../repositories/press/evidence_press_reposity.dart';

class GetAllEvidencePressUseCase extends GetAllEntitiesUseCase<EvidencePress> {
  GetAllEvidencePressUseCase(EvidencePressReposity repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetAreasConveyorByIdUseCase extends GetEntityByIdUseCase<EvidencePress> {
  GetAreasConveyorByIdUseCase(EvidencePressReposity repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateEvidencePressUseCase extends CreateEntityUseCase<EvidencePress> {
  CreateEvidencePressUseCase(EvidencePressReposity repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateEvidencePressUseCase extends UpdateEntityUseCase<EvidencePress> {
  UpdateEvidencePressUseCase(EvidencePressReposity repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteEvidencePressUseCase extends DeleteEntityUseCase<EvidencePress> {
  DeleteEvidencePressUseCase(EvidencePressReposity repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetEvidencePressByAttributeUseCase extends GetEntitiesByAttributeUseCase<EvidencePress> {
  GetEvidencePressByAttributeUseCase(EvidencePressReposity repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchEvidencePressUseCase extends SearchEntitiesUseCase<EvidencePress> {
  SearchEvidencePressUseCase(EvidencePressReposity repository) : super(repository);
}