import '../base_use_case.dart';
import '../../entities/vehicle/vehicle_type.dart';
import '../../repositories/vehicle/vehicle_type_repository.dart';

class GetAllVehicleTypeUseCase extends GetAllEntitiesUseCase<VehicleTypes> {
  GetAllVehicleTypeUseCase(VehicleTypeRepository repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetVehicleTypeByIdUseCase extends GetEntityByIdUseCase<VehicleTypes> {
  GetVehicleTypeByIdUseCase(VehicleTypeRepository repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateVehicleTypeUseCase extends CreateEntityUseCase<VehicleTypes> {
  CreateVehicleTypeUseCase(VehicleTypeRepository repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateVehicleTypeUseCase extends UpdateEntityUseCase<VehicleTypes> {
  UpdateVehicleTypeUseCase(VehicleTypeRepository repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteVehicleTypeUseCase extends DeleteEntityUseCase<VehicleTypes> {
  DeleteVehicleTypeUseCase(VehicleTypeRepository repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetVehicleTypeByAttributeUseCase extends GetEntitiesByAttributeUseCase<VehicleTypes> {
  GetVehicleTypeByAttributeUseCase(VehicleTypeRepository repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchVehicleTypeUseCase extends SearchEntitiesUseCase<VehicleTypes> {
  SearchVehicleTypeUseCase(VehicleTypeRepository repository) : super(repository);
}