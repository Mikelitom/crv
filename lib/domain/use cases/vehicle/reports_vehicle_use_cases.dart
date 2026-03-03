import '../base_use_case.dart';
import '../../entities/vehicle/reports_vehicle.dart';
import '../../repositories/vehicle/reports_vehicle_repository.dart';

class GetAllReportsVehicleUseCase extends GetAllEntitiesUseCase<ReportsVehicle> {
  GetAllReportsVehicleUseCase(ReportsVehicleRepository repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetReportsVehicleByIdUseCase extends GetEntityByIdUseCase<ReportsVehicle> {
  GetReportsVehicleByIdUseCase(ReportsVehicleRepository repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateReportsVehicleUseCase extends CreateEntityUseCase<ReportsVehicle> {
  CreateReportsVehicleUseCase(ReportsVehicleRepository repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateReportsVehicleUseCase extends UpdateEntityUseCase<ReportsVehicle> {
  UpdateReportsVehicleUseCase(ReportsVehicleRepository repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteReportsVehicleUseCase extends DeleteEntityUseCase<ReportsVehicle> {
  DeleteReportsVehicleUseCase(ReportsVehicleRepository repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetReportsVehicleByAttributeUseCase extends GetEntitiesByAttributeUseCase<ReportsVehicle> {
  GetReportsVehicleByAttributeUseCase(ReportsVehicleRepository repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchReportsVehicleUseCase extends SearchEntitiesUseCase<ReportsVehicle> {
  SearchReportsVehicleUseCase(ReportsVehicleRepository repository) : super(repository);
}