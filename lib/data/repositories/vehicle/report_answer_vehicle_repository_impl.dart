import '../../../domain/entities/vehicle/report_answers.dart';
import '../../../domain/repositories/vehicle/report_answers_repository.dart';
import '../../datasources/base_data_source.dart';

class ReportAnswersVehicleRepositoryImpl implements ReportAnswersRepository {
  final BaseDataSource<ReportAnswersVehicle> dataSource;

  ReportAnswersVehicleRepositoryImpl(this.dataSource);

  @override
  Future<List<ReportAnswersVehicle>> getAll() => dataSource.getAll();

  @override
  Future<ReportAnswersVehicle> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(ReportAnswersVehicle item) => dataSource.create(item);

  @override
  Future<void> update(ReportAnswersVehicle item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<ReportAnswersVehicle>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<ReportAnswersVehicle>> search(String query) =>
      dataSource.search(query);
}
