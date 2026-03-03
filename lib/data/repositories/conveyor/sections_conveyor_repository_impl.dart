import '../../../domain/entities/conveyors/sections_conveyor.dart';
import '../../../domain/repositories/conveyor/sections_conveyor_reposity.dart';
import '../../datasources/base_data_source.dart';

class SectionsConveyorRepositoryImpl implements SectionsConveyorReposity {
  final BaseDataSource<SectionsConveyor> dataSource;

  SectionsConveyorRepositoryImpl(this.dataSource);

  @override
  Future<List<SectionsConveyor>> getAll() => dataSource.getAll();

  @override
  Future<SectionsConveyor> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(SectionsConveyor item) => dataSource.create(item);

  @override
  Future<void> update(SectionsConveyor item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<SectionsConveyor>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<SectionsConveyor>> search(String query) =>
      dataSource.search(query);
}
