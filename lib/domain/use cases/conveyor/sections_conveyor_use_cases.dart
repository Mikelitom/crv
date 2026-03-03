import '../base_use_case.dart';
import '../../entities/conveyors/sections_conveyor.dart';
import '../../repositories/conveyor/sections_conveyor_reposity.dart';

class GetAllSectionsConveyorUseCase extends GetAllEntitiesUseCase<SectionsConveyor> {
  GetAllSectionsConveyorUseCase(SectionsConveyorReposity repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetAreasConveyorByIdUseCase extends GetEntityByIdUseCase<SectionsConveyor> {
  GetAreasConveyorByIdUseCase(SectionsConveyorReposity repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateSectionsConveyorUseCase extends CreateEntityUseCase<SectionsConveyor> {
  CreateSectionsConveyorUseCase(SectionsConveyorReposity repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateSectionsConveyorUseCase extends UpdateEntityUseCase<SectionsConveyor> {
  UpdateSectionsConveyorUseCase(SectionsConveyorReposity repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteSectionsConveyorUseCase extends DeleteEntityUseCase<SectionsConveyor> {
  DeleteSectionsConveyorUseCase(SectionsConveyorReposity repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetSectionsConveyorByAttributeUseCase extends GetEntitiesByAttributeUseCase<SectionsConveyor> {
  GetSectionsConveyorByAttributeUseCase(SectionsConveyorReposity repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchSectionsConveyorUseCase extends SearchEntitiesUseCase<SectionsConveyor> {
  SearchSectionsConveyorUseCase(SectionsConveyorReposity repository) : super(repository);
}