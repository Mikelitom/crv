import '../base_use_case.dart';
import '../../entities/conveyors/area.dart';
import '../../repositories/conveyor/area_repository.dart';

class GetAllAreaConveyorUseCase extends GetAllEntitiesUseCase<Area> {
  GetAllAreaConveyorUseCase(AreaRepository repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetAreasConveyorByIdUseCase extends GetEntityByIdUseCase<Area> {
  GetAreasConveyorByIdUseCase(AreaRepository repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateAreaConveyorUseCase extends CreateEntityUseCase<Area> {
  CreateAreaConveyorUseCase(AreaRepository repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateAreaConveyorUseCase extends UpdateEntityUseCase<Area> {
  UpdateAreaConveyorUseCase(AreaRepository repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteAreaConveyorUseCase extends DeleteEntityUseCase<Area> {
  DeleteAreaConveyorUseCase(AreaRepository repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetAreaConveyorByAttributeUseCase extends GetEntitiesByAttributeUseCase<Area> {
  GetAreaConveyorByAttributeUseCase(AreaRepository repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchAreaConveyorUseCase extends SearchEntitiesUseCase<Area> {
  SearchAreaConveyorUseCase(AreaRepository repository) : super(repository);
}