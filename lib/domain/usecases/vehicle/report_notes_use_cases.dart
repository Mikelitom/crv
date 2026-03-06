import '../base_use_case.dart';
import '../../entities/vehicle/report_notes.dart';
import '../../repositories/vehicle/report_notes_repository.dart';

class GetAllReportNotesUseCase extends GetAllEntitiesUseCase<ReportNotesVehicle> {
  GetAllReportNotesUseCase(ReportNotesRepository repository) : super(repository);
}

// 2. Obtener un accesorio por ID (get_by_id)
class GetReportNotesByIdUseCase extends GetEntityByIdUseCase<ReportNotesVehicle> {
  GetReportNotesByIdUseCase(ReportNotesRepository repository) : super(repository);
}

// 3. Crear nuevo accesorio (create)
class CreateReportNotesUseCase extends CreateEntityUseCase<ReportNotesVehicle> {
  CreateReportNotesUseCase(ReportNotesRepository repository) : super(repository);
}

// 4. Actualizar accesorio (update)
class UpdateReportNotesUseCase extends UpdateEntityUseCase<ReportNotesVehicle> {
  UpdateReportNotesUseCase(ReportNotesRepository repository) : super(repository);
}

// 5. Eliminar accesorio (delete)
class DeleteReportNotesUseCase extends DeleteEntityUseCase<ReportNotesVehicle> {
  DeleteReportNotesUseCase(ReportNotesRepository repository) : super(repository);
}

// 6. Buscar por atributo (get_by_attribute)
class GetReportNotesByAttributeUseCase extends GetEntitiesByAttributeUseCase<ReportNotesVehicle> {
  GetReportNotesByAttributeUseCase(ReportNotesRepository repository) : super(repository);
}

// 7. Buscador general (search) - Vital para evitar el Right Overflow
class SearchReportNotesUseCase extends SearchEntitiesUseCase<ReportNotesVehicle> {
  SearchReportNotesUseCase(ReportNotesRepository repository) : super(repository);
}