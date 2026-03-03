import '../base_use_case.dart';
import '../../entities/vehicle/report_answers.dart';
import '../../repositories/vehicle/report_answers_repository.dart';

class GetAllReportAnswersUseCase extends GetAllEntitiesUseCase<ReportAnswersVehicle> {
  GetAllReportAnswersUseCase(ReportAnswersRepository repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetReportAnswersByIdUseCase extends GetEntityByIdUseCase<ReportAnswersVehicle> {
  GetReportAnswersByIdUseCase(ReportAnswersRepository repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateReportAnswersUseCase extends CreateEntityUseCase<ReportAnswersVehicle> {
  CreateReportAnswersUseCase(ReportAnswersRepository repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateReportAnswersUseCase extends UpdateEntityUseCase<ReportAnswersVehicle> {
  UpdateReportAnswersUseCase(ReportAnswersRepository repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteReportAnswersUseCase extends DeleteEntityUseCase<ReportAnswersVehicle> {
  DeleteReportAnswersUseCase(ReportAnswersRepository repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetReportAnswersByAttributeUseCase extends GetEntitiesByAttributeUseCase<ReportAnswersVehicle> {
  GetReportAnswersByAttributeUseCase(ReportAnswersRepository repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchReportAnswersUseCase extends SearchEntitiesUseCase<ReportAnswersVehicle> {
  SearchReportAnswersUseCase(ReportAnswersRepository repository) : super(repository);
}