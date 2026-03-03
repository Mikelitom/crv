import '../../../domain/entities/vehicle/vehicle.dart';
import '../../../domain/repositories/vehicle/vehicle_repository.dart';
import '../../datasources/base_data_source.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final BaseDataSource<Vehicle> dataSource;

  VehicleRepositoryImpl(this.dataSource);

  @override
  Future<List<Vehicle>> getAll() => dataSource.getAll();

  @override
  Future<Vehicle> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(Vehicle item) => dataSource.create(item);

  @override
  Future<void> update(Vehicle item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<Vehicle>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<Vehicle>> search(String query) =>
      dataSource.search(query);
}
