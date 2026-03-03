import '../../../domain/entities/vehicle/vehicle_state.dart';
import '../../../domain/repositories/vehicle/vehicle_state_repository.dart';
import '../../datasources/base_data_source.dart';

class VehicleStateRepositoryImpl implements VehicleStateRepository {
  final BaseDataSource<VehicleState> dataSource;

  VehicleStateRepositoryImpl(this.dataSource);

  @override
  Future<List<VehicleState>> getAll() => dataSource.getAll();

  @override
  Future<VehicleState> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(VehicleState item) => dataSource.create(item);

  @override
  Future<void> update(VehicleState item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<VehicleState>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<VehicleState>> search(String query) =>
      dataSource.search(query);
}
