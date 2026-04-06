import 'package:crv_reprosisa/features/assets/data/models/clients_conveyor_model.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';

abstract class ClientRemoteDatasource {
  Future<ClientsConveyorModel> createClient(CreateClientParams params);
  Future<ClientsConveyorModel> updateClient(String id, CreateClientParams params);
  Future<List<ClientsConveyorModel>> getAllClients();
}
