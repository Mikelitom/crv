import '../base_use_case.dart';
import '../../entities/press/press_reports.dart';
import '../../repositories/press/press_reports_reposity.dart';

class GetAllPressReportsUseCase extends GetAllEntitiesUseCase<PressReports> {
  GetAllPressReportsUseCase(PressReportsReposity repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetAreasConveyorByIdUseCase extends GetEntityByIdUseCase<PressReports> {
  GetAreasConveyorByIdUseCase(PressReportsReposity repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreatePressReportsUseCase extends CreateEntityUseCase<PressReports> {
  CreatePressReportsUseCase(PressReportsReposity repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdatePressReportsUseCase extends UpdateEntityUseCase<PressReports> {
  UpdatePressReportsUseCase(PressReportsReposity repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeletePressReportsUseCase extends DeleteEntityUseCase<PressReports> {
  DeletePressReportsUseCase(PressReportsReposity repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetPressReportsByAttributeUseCase extends GetEntitiesByAttributeUseCase<PressReports> {
  GetPressReportsByAttributeUseCase(PressReportsReposity repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchPressReportsUseCase extends SearchEntitiesUseCase<PressReports> {
  SearchPressReportsUseCase(PressReportsReposity repository) : super(repository);
}