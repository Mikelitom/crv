import '../../../domain/entities/conveyors/clients_conveyor.dart';
import '../../../domain/repositories/conveyor/clients_conveyor_reposity.dart';
import '../../datasources/base_data_source.dart';

class ClientsConveyorRepositoryImpl implements ClientsConveyorReposity {
  final BaseDataSource<ClientsConveyor> dataSource;

  ClientsConveyorRepositoryImpl(this.dataSource);

  @override
  Future<List<ClientsConveyor>> getAll() => dataSource.getAll();

  @override
  Future<ClientsConveyor> getById(String id) => dataSource.getById(id);

  @override
  Future<void> create(ClientsConveyor item) => dataSource.create(item);

  @override
  Future<void> update(ClientsConveyor item) => dataSource.update(item);

  @override
  Future<void> delete(String id) => dataSource.delete(id);

  @override
  Future<List<ClientsConveyor>> getByAttribute(String attr, String value) =>
      dataSource.getByAttribute(attr, value);

  @override
  Future<List<ClientsConveyor>> search(String query) =>
      dataSource.search(query);
}
