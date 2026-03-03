import '../../../domain/entities/press/press_reports.dart';
import '../../../domain/repositories/press/press_reports_reposity.dart';
import '../../datasources/base_data_source.dart';

class PressReportsRepositoryImpl implements PressReportsReposity {
  final BaseDataSource<PressReports> dataSource;

  PressReportsRepositoryImpl(this.dataSource);

  @override
  Future<List<PressReports>> getAll() => dataSource.getAll();

  @override
  Future<PressReports> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(PressReports item) => dataSource.create(item);

  @override
  Future<void> update(PressReports item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<PressReports>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<PressReports>> search(String query) =>
      dataSource.search(query);
}
