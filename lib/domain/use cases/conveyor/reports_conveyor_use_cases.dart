import '../base_use_case.dart';
import '../../entities/conveyors/reports_conveyor.dart';
import '../../repositories/conveyor/reports_conveyor_reposity.dart';

class GetAllReportsConveyorUseCase extends GetAllEntitiesUseCase<ReportsConveyor> {
  GetAllReportsConveyorUseCase(ReportsConveyorReposity repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetAreasConveyorByIdUseCase extends GetEntityByIdUseCase<ReportsConveyor> {
  GetAreasConveyorByIdUseCase(ReportsConveyorReposity repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateReportsConveyorUseCase extends CreateEntityUseCase<ReportsConveyor> {
  CreateReportsConveyorUseCase(ReportsConveyorReposity repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateReportsConveyorUseCase extends UpdateEntityUseCase<ReportsConveyor> {
  UpdateReportsConveyorUseCase(ReportsConveyorReposity repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteReportsConveyorUseCase extends DeleteEntityUseCase<ReportsConveyor> {
  DeleteReportsConveyorUseCase(ReportsConveyorReposity repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetReportsConveyorByAttributeUseCase extends GetEntitiesByAttributeUseCase<ReportsConveyor> {
  GetReportsConveyorByAttributeUseCase(ReportsConveyorReposity repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchReportsConveyorUseCase extends SearchEntitiesUseCase<ReportsConveyor> {
  SearchReportsConveyorUseCase(ReportsConveyorReposity repository) : super(repository);
}