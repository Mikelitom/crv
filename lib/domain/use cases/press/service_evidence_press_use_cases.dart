import '../base_use_case.dart';
import '../../entities/press/service_evidence_press.dart';
import '../../repositories/press/service_evidence_press_reposity.dart';

class GetAllServiceEvidencePressUseCase extends GetAllEntitiesUseCase<ServiceEvidencePress> {
  GetAllServiceEvidencePressUseCase(ServiceEvidencePressReposity repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetAreasConveyorByIdUseCase extends GetEntityByIdUseCase<ServiceEvidencePress> {
  GetAreasConveyorByIdUseCase(ServiceEvidencePressReposity repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateServiceEvidencePressUseCase extends CreateEntityUseCase<ServiceEvidencePress> {
  CreateServiceEvidencePressUseCase(ServiceEvidencePressReposity repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateServiceEvidencePressUseCase extends UpdateEntityUseCase<ServiceEvidencePress> {
  UpdateServiceEvidencePressUseCase(ServiceEvidencePressReposity repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteServiceEvidencePressUseCase extends DeleteEntityUseCase<ServiceEvidencePress> {
  DeleteServiceEvidencePressUseCase(ServiceEvidencePressReposity repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetServiceEvidencePressByAttributeUseCase extends GetEntitiesByAttributeUseCase<ServiceEvidencePress> {
  GetServiceEvidencePressByAttributeUseCase(ServiceEvidencePressReposity repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchServiceEvidencePressUseCase extends SearchEntitiesUseCase<ServiceEvidencePress> {
  SearchServiceEvidencePressUseCase(ServiceEvidencePressReposity repository) : super(repository);
}