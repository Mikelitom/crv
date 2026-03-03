import '../../../domain/entities/vehicle/report_notes.dart';
import '../../../domain/repositories/vehicle/report_notes_repository.dart';
import '../../datasources/base_data_source.dart';

class ReportNotesVehicleRepositoryImpl implements ReportNotesRepository {
  final BaseDataSource<ReportNotesVehicle> dataSource;

  ReportNotesVehicleRepositoryImpl(this.dataSource);

  @override
  Future<List<ReportNotesVehicle>> getAll() => dataSource.getAll();

  @override
  Future<ReportNotesVehicle> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(ReportNotesVehicle item) => dataSource.create(item);

  @override
  Future<void> update(ReportNotesVehicle item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<ReportNotesVehicle>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<ReportNotesVehicle>> search(String query) =>
      dataSource.search(query);
}
