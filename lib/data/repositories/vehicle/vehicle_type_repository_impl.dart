import '../../../domain/entities/vehicle/vehicle_type.dart';
import '../../../domain/repositories/vehicle/vehicle_type_repository.dart';
import '../../datasources/base_data_source.dart';

class VehicleTypesRepositoryImpl implements VehicleTypeRepository {
  final BaseDataSource<VehicleTypes> dataSource;

  VehicleTypesRepositoryImpl(this.dataSource);

  @override
  Future<List<VehicleTypes>> getAll() => dataSource.getAll();

  @override
  Future<VehicleTypes> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(VehicleTypes item) => dataSource.create(item);

  @override
  Future<void> update(VehicleTypes item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<VehicleTypes>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<VehicleTypes>> search(String query) =>
      dataSource.search(query);
}
