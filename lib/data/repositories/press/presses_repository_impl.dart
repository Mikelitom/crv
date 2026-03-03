import '../../../domain/entities/press/presses.dart';
import '../../../domain/repositories/press/presses_reposity.dart';
import '../../datasources/base_data_source.dart';

class PressesReportsRepositoryImpl implements PressesReposity {
  final BaseDataSource<Presses> dataSource;

  PressesReportsRepositoryImpl(this.dataSource);

  @override
  Future<List<Presses>> getAll() => dataSource.getAll();

  @override
  Future<Presses> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(Presses item) => dataSource.create(item);

  @override
  Future<void> update(Presses item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<Presses>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<Presses>> search(String query) =>
      dataSource.search(query);
}
