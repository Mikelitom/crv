import '../base_use_case.dart';
import '../../entities/conveyors/conveyors.dart';
import '../../repositories/conveyor/conveyors_reposity.dart';

class GetAllConveyorsUseCase extends GetAllEntitiesUseCase<Conveyors> {
  GetAllConveyorsUseCase(ConveyorsReposity repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetAreasConveyorByIdUseCase extends GetEntityByIdUseCase<Conveyors> {
  GetAreasConveyorByIdUseCase(ConveyorsReposity repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateConveyorsUseCase extends CreateEntityUseCase<Conveyors> {
  CreateConveyorsUseCase(ConveyorsReposity repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateConveyorsUseCase extends UpdateEntityUseCase<Conveyors> {
  UpdateConveyorsUseCase(ConveyorsReposity repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteConveyorsUseCase extends DeleteEntityUseCase<Conveyors> {
  DeleteConveyorsUseCase(ConveyorsReposity repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetConveyorsByAttributeUseCase extends GetEntitiesByAttributeUseCase<Conveyors> {
  GetConveyorsByAttributeUseCase(ConveyorsReposity repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchConveyorsUseCase extends SearchEntitiesUseCase<Conveyors> {
  SearchConveyorsUseCase(ConveyorsReposity repository) : super(repository);
}