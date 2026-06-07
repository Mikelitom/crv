import 'package:crv_reprosisa/features/assets/data/datasource/client_remote_datasource.dart';
import 'package:crv_reprosisa/features/assets/data/models/client_history_model.dart';
import 'package:crv_reprosisa/features/assets/data/models/conveyor_report_detail_model.dart';
import 'package:crv_reprosisa/features/assets/data/models/create_client_request.dart';
import 'package:crv_reprosisa/features/assets/data/models/clients_model.dart';
import 'package:dio/dio.dart';
import '../../data/models/create_mine_request.dart';


class ClientRemoteDatasourceImpl implements ClientRemoteDatasource {
  final Dio dio;

  ClientRemoteDatasourceImpl(this.dio);

  @override
  Future<ClientsModel> createClient(CreateClientRequest request) async {
    final response = await dio.post('/clients/mines', data: request.toJson());

    return ClientsModel.fromJson(response.data);
  }

  @override
  Future<void> createMine(String clientId, CreateMineRequest request) async {
    await dio.post('/api/v1/mines/', data: request.toJson());
  }

  @override
  Future<ClientsModel> updateClient(
    String id,
    CreateClientRequest request,
  ) async {
    final response = await dio.put('/clients/mines/$id', data: request.toJson());

    return ClientsModel.fromJson(response.data);
  }

  @override
  Future<void> activateClient(String id) async {
    await dio.patch('/clients/restore/$id');
  }

  @override
  Future<void> deleteClient(String id) async {
    await dio.delete('/clients/$id');
  }

  @override
  Future<void> activateMine(String mineId) async {
    await dio.patch('/mines/restore/$mineId');
  }

  @override
  Future<void> deleteMine(String mineId) async {
    await dio.delete('/mines/$mineId');
  }
 @override
Future<List<ClientHistoryModel>> getClientHistory(String clientId) async {
  final response = await dio.get('/asset/client-history?client_id=$clientId');
  return (response.data as List)
      .map((e) => ClientHistoryModel.fromJson(e as Map<String, dynamic>))
      .toList();
}

  @override
  Future<ConveyorReportDetailModel> getReportDetail(String versionId) async {
    final response = await dio.get('/asset/conveyor/$versionId');
    return ConveyorReportDetailModel.fromJson(response.data as Map<String, dynamic>);
  }
  @override
  Future<List<ClientsModel>> getAllClients() async {
    final response = await dio.get("/asset/clients");

    final List<dynamic> data = response.data as List<dynamic>;

    return data.map((json) => ClientsModel.fromJson(json as Map<String, dynamic>)).toList();
  }
  
}