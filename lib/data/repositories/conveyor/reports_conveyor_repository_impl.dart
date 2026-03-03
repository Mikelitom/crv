import '../../../domain/entities/conveyors/reports_conveyor.dart';
import '../../../domain/repositories/conveyor/reports_conveyor_reposity.dart';
import '../../datasources/base_data_source.dart';

class ReportsConveyorRepositoryImpl implements ReportsConveyorReposity {
  final BaseDataSource<ReportsConveyor> dataSource;

  ReportsConveyorRepositoryImpl(this.dataSource);

  @override
  Future<List<ReportsConveyor>> getAll() => dataSource.getAll();

  @override
  Future<ReportsConveyor> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(ReportsConveyor item) => dataSource.create(item);

  @override
  Future<void> update(ReportsConveyor item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<ReportsConveyor>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<ReportsConveyor>> search(String query) =>
      dataSource.search(query);
}
