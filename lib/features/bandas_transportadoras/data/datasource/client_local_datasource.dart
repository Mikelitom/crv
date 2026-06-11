import 'package:crv_reprosisa/features/assets/data/models/clients_model.dart';

abstract class ClientLocalDatasource {
  Future<void> saveClients(List<ClientsModel> clients);
  Future<List<ClientsModel>> getClients();

  
}
