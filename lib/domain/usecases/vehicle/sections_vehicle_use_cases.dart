import '../base_use_case.dart';
import '../../entities/vehicle/sections._vehicle.dart';
import '../../repositories/vehicle/sections_vehicle_repository.dart';

class GetAllSectionsVehicleUseCase extends GetAllEntitiesUseCase<SectionsVehicle> {
  GetAllSectionsVehicleUseCase(SectionsVehicleRepository repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetSectionsVehicleByIdUseCase extends GetEntityByIdUseCase<SectionsVehicle> {
  GetSectionsVehicleByIdUseCase(SectionsVehicleRepository repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateSectionsVehicleUseCase extends CreateEntityUseCase<SectionsVehicle> {
  CreateSectionsVehicleUseCase(SectionsVehicleRepository repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateSectionsVehicleUseCase extends UpdateEntityUseCase<SectionsVehicle> {
  UpdateSectionsVehicleUseCase(SectionsVehicleRepository repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteSectionsVehicleUseCase extends DeleteEntityUseCase<SectionsVehicle> {
  DeleteSectionsVehicleUseCase(SectionsVehicleRepository repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetSectionsVehicleByAttributeUseCase extends GetEntitiesByAttributeUseCase<SectionsVehicle> {
  GetSectionsVehicleByAttributeUseCase(SectionsVehicleRepository repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchSectionsVehicleUseCase extends SearchEntitiesUseCase<SectionsVehicle> {
  SearchSectionsVehicleUseCase(SectionsVehicleRepository repository) : super(repository);
}