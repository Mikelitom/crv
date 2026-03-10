import 'package:crv_reprosisa/features/activos/data/models/clients_conveyor_model.dart';
import 'package:crv_reprosisa/features/activos/domain/params/create_clients_params.dart';

abstract class ClientRemoteDatasource {
  Future<ClientsConveyorModel> createClient(CreateClientParams params);
  Future<List<ClientsConveyorModel>> getAllClients();
}
