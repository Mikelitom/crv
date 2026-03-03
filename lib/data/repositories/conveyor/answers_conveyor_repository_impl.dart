import '../../../domain/entities/conveyors/answers_conveyor.dart';
import '../../../domain/repositories/conveyor/answers_conveyor_repository.dart';
import '../../datasources/base_data_source.dart';

class AnswersConveyorRepositoryImpl implements AnswersConveyorRepository {
  final BaseDataSource<AnswersConveyor> dataSource;

  AnswersConveyorRepositoryImpl(this.dataSource);

  @override
  Future<List<AnswersConveyor>> getAll() => dataSource.getAll();

  @override
  Future<AnswersConveyor> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(AnswersConveyor item) => dataSource.create(item);

  @override
  Future<void> update(AnswersConveyor item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<AnswersConveyor>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<AnswersConveyor>> search(String query) =>
      dataSource.search(query);
}
