import '../../../domain/entities/conveyors/evidence_conveyor.dart';
import '../../../domain/repositories/conveyor/evidence_conveyor_reposity.dart';
import '../../datasources/base_data_source.dart';

class EvidenceConveyorRepositoryImpl implements EvidenceConveyorReposity {
  final BaseDataSource<EvidenceConveyor> dataSource;

  EvidenceConveyorRepositoryImpl(this.dataSource);

  @override
  Future<List<EvidenceConveyor>> getAll() => dataSource.getAll();

  @override
  Future<EvidenceConveyor> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(EvidenceConveyor item) => dataSource.create(item);

  @override
  Future<void> update(EvidenceConveyor item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<EvidenceConveyor>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<EvidenceConveyor>> search(String query) =>
      dataSource.search(query);
}
