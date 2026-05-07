import 'package:crv_reprosisa/features/assets/data/models/create_client_request.dart';
import 'package:crv_reprosisa/features/assets/data/models/clients_model.dart';

abstract class ClientRemoteDatasource {
  Future<ClientsModel> createClient(CreateClientRequest request);
  Future<ClientsModel> updateClient(String id, CreateClientRequest request);
  Future<List<ClientsModel>> getAllClients();
}
