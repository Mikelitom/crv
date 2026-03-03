import '../base_use_case.dart';
import '../../entities/press/presses.dart';
import '../../repositories/press/presses_reposity.dart';

class GetAllPressesUseCase extends GetAllEntitiesUseCase<Presses> {
  GetAllPressesUseCase(PressesReposity repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetAreasConveyorByIdUseCase extends GetEntityByIdUseCase<Presses> {
  GetAreasConveyorByIdUseCase(PressesReposity repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreatePressesUseCase extends CreateEntityUseCase<Presses> {
  CreatePressesUseCase(PressesReposity repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdatePressesUseCase extends UpdateEntityUseCase<Presses> {
  UpdatePressesUseCase(PressesReposity repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeletePressesUseCase extends DeleteEntityUseCase<Presses> {
  DeletePressesUseCase(PressesReposity repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetPressesByAttributeUseCase extends GetEntitiesByAttributeUseCase<Presses> {
  GetPressesByAttributeUseCase(PressesReposity repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchPressesUseCase extends SearchEntitiesUseCase<Presses> {
  SearchPressesUseCase(PressesReposity repository) : super(repository);
}