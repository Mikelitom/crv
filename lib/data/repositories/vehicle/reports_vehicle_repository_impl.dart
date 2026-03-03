import '../../../domain/entities/vehicle/reports_vehicle.dart';
import '../../../domain/repositories/vehicle/reports_vehicle_repository.dart';
import '../../datasources/base_data_source.dart';

class ReportsVehicleRepositoryImpl implements ReportsVehicleRepository {
  final BaseDataSource<ReportsVehicle> dataSource;

  ReportsVehicleRepositoryImpl(this.dataSource);

  @override
  Future<List<ReportsVehicle>> getAll() => dataSource.getAll();

  @override
  Future<ReportsVehicle> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(ReportsVehicle item) => dataSource.create(item);

  @override
  Future<void> update(ReportsVehicle item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<ReportsVehicle>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<ReportsVehicle>> search(String query) =>
      dataSource.search(query);
}
