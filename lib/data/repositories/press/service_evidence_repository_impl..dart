import '../../../domain/entities/press/service_evidence_press.dart';
import '../../../domain/repositories/press/service_evidence_press_reposity.dart';
import '../../datasources/base_data_source.dart';

class ServiceEvidencePressReportsRepositoryImpl implements ServiceEvidencePressReposity {
  final BaseDataSource<ServiceEvidencePress> dataSource;

  ServiceEvidencePressReportsRepositoryImpl(this.dataSource);

  @override
  Future<List<ServiceEvidencePress>> getAll() => dataSource.getAll();

  @override
  Future<ServiceEvidencePress> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(ServiceEvidencePress item) => dataSource.create(item);

  @override
  Future<void> update(ServiceEvidencePress item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<ServiceEvidencePress>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<ServiceEvidencePress>> search(String query) =>
      dataSource.search(query);
}
