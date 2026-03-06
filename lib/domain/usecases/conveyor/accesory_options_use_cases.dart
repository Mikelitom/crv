import '../base_use_case.dart';
import '../../entities/conveyors/accesory_options_conveyor.dart';
import '../../repositories/conveyor/accesory_options_repository.dart';

class GetAllAccesoriesOptionsUseCase extends GetAllEntitiesUseCase<AccesoryOptionsConveyor> {
  GetAllAccesoriesOptionsUseCase(AccesoryOptionsRepository repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetAccesoryOptionByIdUseCase extends GetEntityByIdUseCase<AccesoryOptionsConveyor> {
  GetAccesoryOptionByIdUseCase(AccesoryOptionsRepository repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateAccesoryOptionUseCase extends CreateEntityUseCase<AccesoryOptionsConveyor> {
  CreateAccesoryOptionUseCase(AccesoryOptionsRepository repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateAccesoryOptionUseCase extends UpdateEntityUseCase<AccesoryOptionsConveyor> {
  UpdateAccesoryOptionUseCase(AccesoryOptionsRepository repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteAccesoryOptionUseCase extends DeleteEntityUseCase<AccesoryOptionsConveyor> {
  DeleteAccesoryOptionUseCase(AccesoryOptionsRepository repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetAccesoriesOptionsByAttributeUseCase extends GetEntitiesByAttributeUseCase<AccesoryOptionsConveyor> {
  GetAccesoriesOptionsByAttributeUseCase(AccesoryOptionsRepository repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchAccesoriesOptionsUseCase extends SearchEntitiesUseCase<AccesoryOptionsConveyor> {
  SearchAccesoriesOptionsUseCase(AccesoryOptionsRepository repository) : super(repository);
}