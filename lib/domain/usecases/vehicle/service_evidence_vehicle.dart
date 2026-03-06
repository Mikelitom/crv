import '../base_use_case.dart';
import '../../entities/vehicle/service_evidence_vehicle.dart';
import '../../repositories/vehicle/service_evidence_repository.dart';

class GetAllServiceEvidenceVehicleUseCase extends GetAllEntitiesUseCase<ServiceEvidenceVehicle> {
  GetAllServiceEvidenceVehicleUseCase(ServiceEvidenceRepository repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetServiceEvidenceVehicleByIdUseCase extends GetEntityByIdUseCase<ServiceEvidenceVehicle> {
  GetServiceEvidenceVehicleByIdUseCase(ServiceEvidenceRepository repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateServiceEvidenceVehicleUseCase extends CreateEntityUseCase<ServiceEvidenceVehicle> {
  CreateServiceEvidenceVehicleUseCase(ServiceEvidenceRepository repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateServiceEvidenceVehicleUseCase extends UpdateEntityUseCase<ServiceEvidenceVehicle> {
  UpdateServiceEvidenceVehicleUseCase(ServiceEvidenceRepository repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteServiceEvidenceVehicleUseCase extends DeleteEntityUseCase<ServiceEvidenceVehicle> {
  DeleteServiceEvidenceVehicleUseCase(ServiceEvidenceRepository repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetServiceEvidenceVehicleByAttributeUseCase extends GetEntitiesByAttributeUseCase<ServiceEvidenceVehicle> {
  GetServiceEvidenceVehicleByAttributeUseCase(ServiceEvidenceRepository repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchServiceEvidenceVehicleUseCase extends SearchEntitiesUseCase<ServiceEvidenceVehicle> {
  SearchServiceEvidenceVehicleUseCase(ServiceEvidenceRepository repository) : super(repository);
}