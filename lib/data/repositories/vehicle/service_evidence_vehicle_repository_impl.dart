import '../../../domain/entities/vehicle/service_evidence_vehicle.dart';
import '../../../domain/repositories/vehicle/service_evidence_repository.dart';
import '../../datasources/base_data_source.dart';

class ServiceEvidenceVehicleRepositoryImpl implements ServiceEvidenceRepository {
  final BaseDataSource<ServiceEvidenceVehicle> dataSource;

  ServiceEvidenceVehicleRepositoryImpl(this.dataSource);

  @override
  Future<List<ServiceEvidenceVehicle>> getAll() => dataSource.getAll();

  @override
  Future<ServiceEvidenceVehicle> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(ServiceEvidenceVehicle item) => dataSource.create(item);

  @override
  Future<void> update(ServiceEvidenceVehicle item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<ServiceEvidenceVehicle>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<ServiceEvidenceVehicle>> search(String query) =>
      dataSource.search(query);
}
