import '../../../domain/entities/vehicle/evidence_vehicle.dart';
import '../../../domain/repositories/vehicle/evidence_vehicle_repository.dart';
import '../../datasources/base_data_source.dart';

class EvidenceVehicleRepositoryImpl implements EvidenceVehicleRepository {
  final BaseDataSource<EvidenceVehicle> dataSource;

  EvidenceVehicleRepositoryImpl(this.dataSource);

  @override
  Future<List<EvidenceVehicle>> getAll() => dataSource.getAll();

  @override
  Future<EvidenceVehicle> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(EvidenceVehicle item) => dataSource.create(item);

  @override
  Future<void> update(EvidenceVehicle item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<EvidenceVehicle>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<EvidenceVehicle>> search(String query) =>
      dataSource.search(query);
}
