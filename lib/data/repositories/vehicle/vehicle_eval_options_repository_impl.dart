import '../../../domain/entities/vehicle/vehicle_eval_options.dart';
import '../../../domain/repositories/vehicle/vehicle_eval_options_repository.dart';
import '../../datasources/base_data_source.dart';

class VehicleEvalOptionsRepositoryImpl implements VehicleEvalOptionsRepository {
  final BaseDataSource<VehicleEvalOptions> dataSource;

  VehicleEvalOptionsRepositoryImpl(this.dataSource);

  @override
  Future<List<VehicleEvalOptions>> getAll() => dataSource.getAll();

  @override
  Future<VehicleEvalOptions> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(VehicleEvalOptions item) => dataSource.create(item);

  @override
  Future<void> update(VehicleEvalOptions item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<VehicleEvalOptions>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<VehicleEvalOptions>> search(String query) =>
      dataSource.search(query);
}
