import 'package:crv_reprosisa/features/assets/data/models/clients_model.dart';

abstract class ClientLocalDatasource {
  Future<void> saveClients(List<ClientsModel> clients);
  Future<List<ClientsModel>> getClients();

  Future<void> saveClientTemplate(Map<String, dynamic> template);
  Future<Map<String, dynamic>> getClientTemplate();

  // Future<void> saveOfflineReport(Map<String, dynamic> report);
}
