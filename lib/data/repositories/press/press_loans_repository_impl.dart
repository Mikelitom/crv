import '../../../domain/entities/press/press_loans.dart';
import '../../../domain/repositories/press/press_loans_reposity.dart';
import '../../datasources/base_data_source.dart';

class PressLoansRepositoryImpl implements PressLoansReposity {
  final BaseDataSource<PressLoans> dataSource;

  PressLoansRepositoryImpl(this.dataSource);

  @override
  Future<List<PressLoans>> getAll() => dataSource.getAll();

  @override
  Future<PressLoans> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(PressLoans item) => dataSource.create(item);

  @override
  Future<void> update(PressLoans item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<PressLoans>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<PressLoans>> search(String query) =>
      dataSource.search(query);
}
