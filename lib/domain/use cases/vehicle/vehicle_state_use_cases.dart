import '../base_use_case.dart';
import '../../entities/vehicle/vehicle_state.dart';
import '../../repositories/vehicle/vehicle_state_repository.dart';

class GetAllVehicleStateUseCase extends GetAllEntitiesUseCase<VehicleState> {
  GetAllVehicleStateUseCase(VehicleStateRepository repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetVehicleStateByIdUseCase extends GetEntityByIdUseCase<VehicleState> {
  GetVehicleStateByIdUseCase(VehicleStateRepository repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateVehicleStateUseCase extends CreateEntityUseCase<VehicleState> {
  CreateVehicleStateUseCase(VehicleStateRepository repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateVehicleStateUseCase extends UpdateEntityUseCase<VehicleState> {
  UpdateVehicleStateUseCase(VehicleStateRepository repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteVehicleStateUseCase extends DeleteEntityUseCase<VehicleState> {
  DeleteVehicleStateUseCase(VehicleStateRepository repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetVehicleStateByAttributeUseCase extends GetEntitiesByAttributeUseCase<VehicleState> {
  GetVehicleStateByAttributeUseCase(VehicleStateRepository repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchVehicleStateUseCase extends SearchEntitiesUseCase<VehicleState> {
  SearchVehicleStateUseCase(VehicleStateRepository repository) : super(repository);
}