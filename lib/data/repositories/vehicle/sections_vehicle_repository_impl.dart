import '../../../domain/entities/vehicle/sections._vehicle.dart';
import '../../../domain/repositories/vehicle/sections_vehicle_repository.dart';
import '../../datasources/base_data_source.dart';

class SectionsVehicleRepositoryImpl implements SectionsVehicleRepository {
  final BaseDataSource<SectionsVehicle> dataSource;

  SectionsVehicleRepositoryImpl(this.dataSource);

  @override
  Future<List<SectionsVehicle>> getAll() => dataSource.getAll();

  @override
  Future<SectionsVehicle> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(SectionsVehicle item) => dataSource.create(item);

  @override
  Future<void> update(SectionsVehicle item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<SectionsVehicle>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<SectionsVehicle>> search(String query) =>
      dataSource.search(query);
}
