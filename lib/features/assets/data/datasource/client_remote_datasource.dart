import 'package:crv_reprosisa/features/assets/data/models/create_client_request.dart';
import 'package:crv_reprosisa/features/assets/data/models/clients_model.dart';
import '../../data/models/create_mine_request.dart';

abstract class ClientRemoteDatasource {
  Future<ClientsModel> createClient(CreateClientRequest request);
  Future<ClientsModel> updateClient(String id, CreateClientRequest request);
  Future<List<ClientsModel>> getAllClients();
  Future<void> activateClient(String id);
  Future<void> deleteClient(String id);
  Future<void> activateMine(String mineId);
  Future<void> deleteMine(String mineId);
  Future<void> createMine(String clientId, CreateMineRequest request);
}
