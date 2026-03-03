import '../../../domain/entities/conveyors/area.dart';
import '../../../domain/repositories/conveyor/area_repository.dart';
import '../../datasources/base_data_source.dart';

class AreaRepositoryImpl implements AreaRepository {
  final BaseDataSource<Area> dataSource;

  AreaRepositoryImpl(this.dataSource);

  @override
  Future<List<Area>> getAll() => dataSource.getAll();

  @override
  Future<Area> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(Area item) => dataSource.create(item);

  @override
  Future<void> update(Area item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<Area>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<Area>> search(String query) =>
      dataSource.search(query);
}
