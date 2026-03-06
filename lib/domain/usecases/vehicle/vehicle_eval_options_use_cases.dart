import '../base_use_case.dart';
import '../../entities/vehicle/vehicle_eval_options.dart';
import '../../repositories/vehicle/vehicle_eval_options_repository.dart';

class GetAllVehicleEvalOptionsUseCase extends GetAllEntitiesUseCase<VehicleEvalOptions> {
  GetAllVehicleEvalOptionsUseCase(VehicleEvalOptionsRepository repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetVehicleEvalOptionsByIdUseCase extends GetEntityByIdUseCase<VehicleEvalOptions> {
  GetVehicleEvalOptionsByIdUseCase(VehicleEvalOptionsRepository repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateVehicleEvalOptionsUseCase extends CreateEntityUseCase<VehicleEvalOptions> {
  CreateVehicleEvalOptionsUseCase(VehicleEvalOptionsRepository repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateVehicleEvalOptionsUseCase extends UpdateEntityUseCase<VehicleEvalOptions> {
  UpdateVehicleEvalOptionsUseCase(VehicleEvalOptionsRepository repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteVehicleEvalOptionsUseCase extends DeleteEntityUseCase<VehicleEvalOptions> {
  DeleteVehicleEvalOptionsUseCase(VehicleEvalOptionsRepository repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetVehicleEvalOptionsByAttributeUseCase extends GetEntitiesByAttributeUseCase<VehicleEvalOptions> {
  GetVehicleEvalOptionsByAttributeUseCase(VehicleEvalOptionsRepository repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchVehicleEvalOptionsUseCase extends SearchEntitiesUseCase<VehicleEvalOptions> {
  SearchVehicleEvalOptionsUseCase(VehicleEvalOptionsRepository repository) : super(repository);
}