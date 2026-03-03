import '../base_use_case.dart';
import '../../entities/press/component_press.dart';
import '../../repositories/press/component_press_reposity.dart';

class GetAllComponentPressUseCase extends GetAllEntitiesUseCase<ComponentPress> {
  GetAllComponentPressUseCase(ComponentPressReposity repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetAreasConveyorByIdUseCase extends GetEntityByIdUseCase<ComponentPress> {
  GetAreasConveyorByIdUseCase(ComponentPressReposity repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateComponentPressUseCase extends CreateEntityUseCase<ComponentPress> {
  CreateComponentPressUseCase(ComponentPressReposity repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateComponentPressUseCase extends UpdateEntityUseCase<ComponentPress> {
  UpdateComponentPressUseCase(ComponentPressReposity repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteComponentPressUseCase extends DeleteEntityUseCase<ComponentPress> {
  DeleteComponentPressUseCase(ComponentPressReposity repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetComponentPressByAttributeUseCase extends GetEntitiesByAttributeUseCase<ComponentPress> {
  GetComponentPressByAttributeUseCase(ComponentPressReposity repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchComponentPressUseCase extends SearchEntitiesUseCase<ComponentPress> {
  SearchComponentPressUseCase(ComponentPressReposity repository) : super(repository);
}