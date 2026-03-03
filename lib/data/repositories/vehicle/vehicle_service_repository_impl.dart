import '../../../domain/entities/vehicle/vehicle_service.dart';
import '../../../domain/repositories/vehicle/vehicle_service_repository.dart';
import '../../datasources/base_data_source.dart';

class VehicleServiceRepositoryImpl implements VehicleServiceRepository {
  final BaseDataSource<VehicleService> dataSource;

  VehicleServiceRepositoryImpl(this.dataSource);

  @override
  Future<List<VehicleService>> getAll() => dataSource.getAll();

  @override
  Future<VehicleService> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(VehicleService item) => dataSource.create(item);

  @override
  Future<void> update(VehicleService item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<VehicleService>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<VehicleService>> search(String query) =>
      dataSource.search(query);
}
