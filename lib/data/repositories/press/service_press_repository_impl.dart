import '../../../domain/entities/press/service_press.dart';
import '../../../domain/repositories/press/service_press_reposity.dart';
import '../../datasources/base_data_source.dart';

class ServicePressRepositoryImpl implements ServicePressReposity {
  final BaseDataSource<ServicePress> dataSource;

  ServicePressRepositoryImpl(this.dataSource);

  @override
  Future<List<ServicePress>> getAll() => dataSource.getAll();

  @override
  Future<ServicePress> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(ServicePress item) => dataSource.create(item);

  @override
  Future<void> update(ServicePress item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<ServicePress>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<ServicePress>> search(String query) =>
      dataSource.search(query);
}
