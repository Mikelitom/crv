import '../../../domain/entities/press/evidence_press.dart';
import '../../../domain/repositories/press/evidence_press_reposity.dart';
import '../../datasources/base_data_source.dart';

class EvidencePressRepositoryImpl implements EvidencePressReposity {
  final BaseDataSource<EvidencePress> dataSource;

  EvidencePressRepositoryImpl(this.dataSource);

  @override
  Future<List<EvidencePress>> getAll() => dataSource.getAll();

  @override
  Future<EvidencePress> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(EvidencePress item) => dataSource.create(item);

  @override
  Future<void> update(EvidencePress item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<EvidencePress>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<EvidencePress>> search(String query) =>
      dataSource.search(query);
}
