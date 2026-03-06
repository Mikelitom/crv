import '../base_use_case.dart';
import '../../entities/vehicle/vehicle.dart';
import '../../repositories/vehicle/vehicle_repository.dart';

class GetAllVehicleUseCase extends GetAllEntitiesUseCase<Vehicle> {
  GetAllVehicleUseCase(VehicleRepository repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetVehicleByIdUseCase extends GetEntityByIdUseCase<Vehicle> {
  GetVehicleByIdUseCase(VehicleRepository repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateVehicleUseCase extends CreateEntityUseCase<Vehicle> {
  CreateVehicleUseCase(VehicleRepository repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateVehicleUseCase extends UpdateEntityUseCase<Vehicle> {
  UpdateVehicleUseCase(VehicleRepository repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteVehicleUseCase extends DeleteEntityUseCase<Vehicle> {
  DeleteVehicleUseCase(VehicleRepository repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetVehicleByAttributeUseCase extends GetEntitiesByAttributeUseCase<Vehicle> {
  GetVehicleByAttributeUseCase(VehicleRepository repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchVehicleUseCase extends SearchEntitiesUseCase<Vehicle> {
  SearchVehicleUseCase(VehicleRepository repository) : super(repository);
}