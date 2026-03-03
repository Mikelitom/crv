import '../../../domain/entities/press/component_press.dart';
import '../../../domain/repositories/press/component_press_reposity.dart';
import '../../datasources/base_data_source.dart';

class ComponentPressRepositoryImpl implements ComponentPressReposity {
  final BaseDataSource<ComponentPress> dataSource;

  ComponentPressRepositoryImpl(this.dataSource);

  @override
  Future<List<ComponentPress>> getAll() => dataSource.getAll();

  @override
  Future<ComponentPress> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(ComponentPress item) => dataSource.create(item);

  @override
  Future<void> update(ComponentPress item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<ComponentPress>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<ComponentPress>> search(String query) =>
      dataSource.search(query);
}
