import '../base_use_case.dart';
import '../../entities/vehicle/component_vehicle.dart';
import '../../repositories/vehicle/component_vehicle_repository.dart';

class GetAllComponentVehicleUseCase extends GetAllEntitiesUseCase<ComponentVehicle> {
  GetAllComponentVehicleUseCase(ComponentVehicleRepository repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetComponentVehicleByIdUseCase extends GetEntityByIdUseCase<ComponentVehicle> {
  GetComponentVehicleByIdUseCase(ComponentVehicleRepository repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateComponentVehicleUseCase extends CreateEntityUseCase<ComponentVehicle> {
  CreateComponentVehicleUseCase(ComponentVehicleRepository repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateComponentVehicleUseCase extends UpdateEntityUseCase<ComponentVehicle> {
  UpdateComponentVehicleUseCase(ComponentVehicleRepository repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteComponentVehicleUseCase extends DeleteEntityUseCase<ComponentVehicle> {
  DeleteComponentVehicleUseCase(ComponentVehicleRepository repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetComponentVehicleByAttributeUseCase extends GetEntitiesByAttributeUseCase<ComponentVehicle> {
  GetComponentVehicleByAttributeUseCase(ComponentVehicleRepository repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchComponentVehicleUseCase extends SearchEntitiesUseCase<ComponentVehicle> {
  SearchComponentVehicleUseCase(ComponentVehicleRepository repository) : super(repository);
}