import '../../../domain/entities/conveyors/conveyors.dart';
import '../../../domain/repositories/conveyor/conveyors_reposity.dart';
import '../../datasources/base_data_source.dart';

class ConveyorsRepositoryImpl implements ConveyorsReposity {
  final BaseDataSource<Conveyors> dataSource;

  ConveyorsRepositoryImpl(this.dataSource);

  @override
  Future<List<Conveyors>> getAll() => dataSource.getAll();

  @override
  Future<Conveyors> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(Conveyors item) => dataSource.create(item);

  @override
  Future<void> update(Conveyors item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<Conveyors>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<Conveyors>> search(String query) =>
      dataSource.search(query);
}
