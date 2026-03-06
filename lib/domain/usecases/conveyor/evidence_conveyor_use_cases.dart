import '../base_use_case.dart';
import '../../entities/conveyors/evidence_conveyor.dart';
import '../../repositories/conveyor/evidence_conveyor_reposity.dart';

class GetAllEvidenceConveyorUseCase extends GetAllEntitiesUseCase<EvidenceConveyor> {
  GetAllEvidenceConveyorUseCase(EvidenceConveyorReposity repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetAreasConveyorByIdUseCase extends GetEntityByIdUseCase<EvidenceConveyor> {
  GetAreasConveyorByIdUseCase(EvidenceConveyorReposity repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateEvidenceConveyorUseCase extends CreateEntityUseCase<EvidenceConveyor> {
  CreateEvidenceConveyorUseCase(EvidenceConveyorReposity repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateEvidenceConveyorUseCase extends UpdateEntityUseCase<EvidenceConveyor> {
  UpdateEvidenceConveyorUseCase(EvidenceConveyorReposity repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteEvidenceConveyorUseCase extends DeleteEntityUseCase<EvidenceConveyor> {
  DeleteEvidenceConveyorUseCase(EvidenceConveyorReposity repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetEvidenceConveyorByAttributeUseCase extends GetEntitiesByAttributeUseCase<EvidenceConveyor> {
  GetEvidenceConveyorByAttributeUseCase(EvidenceConveyorReposity repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchEvidenceConveyorUseCase extends SearchEntitiesUseCase<EvidenceConveyor> {
  SearchEvidenceConveyorUseCase(EvidenceConveyorReposity repository) : super(repository);
}