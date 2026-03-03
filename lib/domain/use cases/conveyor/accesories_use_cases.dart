import '../base_use_case.dart';
import '../../entities/conveyors/accesories_conveyor.dart';
import '../../repositories/conveyor/accesories_repository.dart';

class GetAllAccesoriesUseCase extends GetAllEntitiesUseCase<AccesoriesConveyor> {
  GetAllAccesoriesUseCase(AccesoriesRepository repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetAccesoryByIdUseCase extends GetEntityByIdUseCase<AccesoriesConveyor> {
  GetAccesoryByIdUseCase(AccesoriesRepository repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateAccesoryUseCase extends CreateEntityUseCase<AccesoriesConveyor> {
  CreateAccesoryUseCase(AccesoriesRepository repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateAccesoryUseCase extends UpdateEntityUseCase<AccesoriesConveyor> {
  UpdateAccesoryUseCase(AccesoriesRepository repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteAccesoryUseCase extends DeleteEntityUseCase<AccesoriesConveyor> {
  DeleteAccesoryUseCase(AccesoriesRepository repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetAccesoriesByAttributeUseCase extends GetEntitiesByAttributeUseCase<AccesoriesConveyor> {
  GetAccesoriesByAttributeUseCase(AccesoriesRepository repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchAccesoriesUseCase extends SearchEntitiesUseCase<AccesoriesConveyor> {
  SearchAccesoriesUseCase(AccesoriesRepository repository) : super(repository);
}