import '../../../domain/entities/vehicle/component_vehicle.dart';
import '../../../domain/repositories/vehicle/component_vehicle_repository.dart';
import '../../datasources/base_data_source.dart';

class ComponentVehicleRepositoryImpl implements ComponentVehicleRepository {
  final BaseDataSource<ComponentVehicle> dataSource;

  ComponentVehicleRepositoryImpl(this.dataSource);

  @override
  Future<List<ComponentVehicle>> getAll() => dataSource.getAll();

  @override
  Future<ComponentVehicle> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(ComponentVehicle item) => dataSource.create(item);

  @override
  Future<void> update(ComponentVehicle item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<ComponentVehicle>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<ComponentVehicle>> search(String query) =>
      dataSource.search(query);
}
