import '../base_use_case.dart';
import '../../entities/conveyors/answers_conveyor.dart';
import '../../repositories/conveyor/answers_conveyor_repository.dart';

class GetAllAnswerConveyorUseCase extends GetAllEntitiesUseCase<AnswersConveyor> {
  GetAllAnswerConveyorUseCase(AnswersConveyorRepository repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetAnswersConveyorByIdUseCase extends GetEntityByIdUseCase<AnswersConveyor> {
  GetAnswersConveyorByIdUseCase(AnswersConveyorRepository repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateAnswerConveyorUseCase extends CreateEntityUseCase<AnswersConveyor> {
  CreateAnswerConveyorUseCase(AnswersConveyorRepository repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateAnswerConveyorUseCase extends UpdateEntityUseCase<AnswersConveyor> {
  UpdateAnswerConveyorUseCase(AnswersConveyorRepository repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteAnswerConveyorUseCase extends DeleteEntityUseCase<AnswersConveyor> {
  DeleteAnswerConveyorUseCase(AnswersConveyorRepository repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetAnswerConveyorByAttributeUseCase extends GetEntitiesByAttributeUseCase<AnswersConveyor> {
  GetAnswerConveyorByAttributeUseCase(AnswersConveyorRepository repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchAnswerConveyorUseCase extends SearchEntitiesUseCase<AnswersConveyor> {
  SearchAnswerConveyorUseCase(AnswersConveyorRepository repository) : super(repository);
}