import '../../domain/repositories/base_repository.dart';
import '../datasources/base_data_source.dart';

class BaseDataRepository<T> implements BaseRepository<T> {
  final BaseDataSource<T> dataSource;

  BaseDataRepository({required this.dataSource});

  @override
  Future<List<T>> getAll() async => await dataSource.getAll();

  @override
  Future<T> getById(String id) async => await dataSource.getById(id);

  @override
  Future<void> create(T item) async => await dataSource.create(item);

  @override
  Future<void> update(T item) async => await dataSource.update(item);

  @override
  Future<void> delete(String id) async => await dataSource.delete(id);

  @override
  Future<List<T>> getByAttribute(String attr, String value) async => 
      await dataSource.getByAttribute(attr, value);

  @override
  Future<List<T>> search(String query) async => await dataSource.search(query);
}