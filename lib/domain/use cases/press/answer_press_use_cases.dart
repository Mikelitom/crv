import '../base_use_case.dart';
import '../../entities/press/answers_press.dart';
import '../../repositories/press/answers_press_reposity.dart';

class GetAllAnswersPressUseCase extends GetAllEntitiesUseCase<AnswersPress> {
  GetAllAnswersPressUseCase(AnswersPressReposity repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetAreasConveyorByIdUseCase extends GetEntityByIdUseCase<AnswersPress> {
  GetAreasConveyorByIdUseCase(AnswersPressReposity repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateAnswersPressUseCase extends CreateEntityUseCase<AnswersPress> {
  CreateAnswersPressUseCase(AnswersPressReposity repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateAnswersPressUseCase extends UpdateEntityUseCase<AnswersPress> {
  UpdateAnswersPressUseCase(AnswersPressReposity repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteAnswersPressUseCase extends DeleteEntityUseCase<AnswersPress> {
  DeleteAnswersPressUseCase(AnswersPressReposity repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetAnswersPressByAttributeUseCase extends GetEntitiesByAttributeUseCase<AnswersPress> {
  GetAnswersPressByAttributeUseCase(AnswersPressReposity repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchAnswersPressUseCase extends SearchEntitiesUseCase<AnswersPress> {
  SearchAnswersPressUseCase(AnswersPressReposity repository) : super(repository);
}