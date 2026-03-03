import '../../../domain/entities/conveyors/accesory_options_conveyor.dart';
import '../../../domain/repositories/conveyor/accesory_options_repository.dart';
import '../../datasources/base_data_source.dart';

class AccesoriesOptionsRepositoryImpl implements AccesoryOptionsRepository {
  final BaseDataSource<AccesoryOptionsConveyor> dataSource;

  AccesoriesOptionsRepositoryImpl(this.dataSource);

  @override
  Future<List<AccesoryOptionsConveyor>> getAll() => dataSource.getAll();

  @override
  Future<AccesoryOptionsConveyor> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(AccesoryOptionsConveyor item) => dataSource.create(item);

  @override
  Future<void> update(AccesoryOptionsConveyor item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<AccesoryOptionsConveyor>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<AccesoryOptionsConveyor>> search(String query) =>
      dataSource.search(query);
}
