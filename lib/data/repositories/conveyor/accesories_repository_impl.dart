import '../../../domain/entities/conveyors/accesories_conveyor.dart';
import '../../../domain/repositories/conveyor/accesories_repository.dart';
import '../../datasources/base_data_source.dart';

class AccesoriesRepositoryImpl implements AccesoriesRepository {
  final BaseDataSource<AccesoriesConveyor> dataSource;

  AccesoriesRepositoryImpl(this.dataSource);

  @override
  Future<List<AccesoriesConveyor>> getAll() => dataSource.getAll();

  @override
  Future<AccesoriesConveyor> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(AccesoriesConveyor item) => dataSource.create(item);

  @override
  Future<void> update(AccesoriesConveyor item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<AccesoriesConveyor>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<AccesoriesConveyor>> search(String query) =>
      dataSource.search(query);
}
