import '../../../domain/entities/press/answers_press.dart';
import '../../../domain/repositories/press/answers_press_reposity.dart';
import '../../datasources/base_data_source.dart';

class AnswersPressRepositoryImpl implements AnswersPressReposity {
  final BaseDataSource<AnswersPress> dataSource;

  AnswersPressRepositoryImpl(this.dataSource);

  @override
  Future<List<AnswersPress>> getAll() => dataSource.getAll();

  @override
  Future<AnswersPress> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(AnswersPress item) => dataSource.create(item);

  @override
  Future<void> update(AnswersPress item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<AnswersPress>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<AnswersPress>> search(String query) =>
      dataSource.search(query);
}
