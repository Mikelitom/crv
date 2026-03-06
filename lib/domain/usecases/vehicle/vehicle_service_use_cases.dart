import '../base_use_case.dart';
import '../../entities/vehicle/vehicle_service.dart';
import '../../repositories/vehicle/vehicle_service_repository.dart';

class GetAllVehicleServiceUseCase extends GetAllEntitiesUseCase<VehicleService> {
  GetAllVehicleServiceUseCase(VehicleServiceRepository repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetVehicleServiceByIdUseCase extends GetEntityByIdUseCase<VehicleService> {
  GetVehicleServiceByIdUseCase(VehicleServiceRepository repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateVehicleServiceUseCase extends CreateEntityUseCase<VehicleService> {
  CreateVehicleServiceUseCase(VehicleServiceRepository repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateVehicleServiceUseCase extends UpdateEntityUseCase<VehicleService> {
  UpdateVehicleServiceUseCase(VehicleServiceRepository repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteVehicleServiceUseCase extends DeleteEntityUseCase<VehicleService> {
  DeleteVehicleServiceUseCase(VehicleServiceRepository repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetVehicleServiceByAttributeUseCase extends GetEntitiesByAttributeUseCase<VehicleService> {
  GetVehicleServiceByAttributeUseCase(VehicleServiceRepository repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchVehicleServiceUseCase extends SearchEntitiesUseCase<VehicleService> {
  SearchVehicleServiceUseCase(VehicleServiceRepository repository) : super(repository);
}