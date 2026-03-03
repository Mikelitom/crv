import '../base_use_case.dart';
import '../../entities/vehicle/evidence_vehicle.dart';
import '../../repositories/vehicle/evidence_vehicle_repository.dart';

class GetAllEvidenceVehicleUseCase extends GetAllEntitiesUseCase<EvidenceVehicle> {
  GetAllEvidenceVehicleUseCase(EvidenceVehicleRepository repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetEvidenceVehicleByIdUseCase extends GetEntityByIdUseCase<EvidenceVehicle> {
  GetEvidenceVehicleByIdUseCase(EvidenceVehicleRepository repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateEvidenceVehicleUseCase extends CreateEntityUseCase<EvidenceVehicle> {
  CreateEvidenceVehicleUseCase(EvidenceVehicleRepository repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateEvidenceVehicleUseCase extends UpdateEntityUseCase<EvidenceVehicle> {
  UpdateEvidenceVehicleUseCase(EvidenceVehicleRepository repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteEvidenceVehicleUseCase extends DeleteEntityUseCase<EvidenceVehicle> {
  DeleteEvidenceVehicleUseCase(EvidenceVehicleRepository repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetEvidenceVehicleByAttributeUseCase extends GetEntitiesByAttributeUseCase<EvidenceVehicle> {
  GetEvidenceVehicleByAttributeUseCase(EvidenceVehicleRepository repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchEvidenceVehicleUseCase extends SearchEntitiesUseCase<EvidenceVehicle> {
  SearchEvidenceVehicleUseCase(EvidenceVehicleRepository repository) : super(repository);
}