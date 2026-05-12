import 'package:crv_reprosisa/features/assets/data/datasource/client_remote_datasource.dart';
import 'package:crv_reprosisa/features/assets/data/models/create_client_request.dart';
import 'package:crv_reprosisa/features/assets/data/models/clients_model.dart';
import 'package:dio/dio.dart';

class ClientRemoteDatasourceImpl implements ClientRemoteDatasource {
  final Dio dio;

  ClientRemoteDatasourceImpl(this.dio);

  @override
  Future<ClientsModel> createClient(CreateClientRequest request) async {
    final response = await dio.post('/clients/mines', data: request.toJson());

    return ClientsModel.fromJson(response.data);
  }

  @override
  Future<ClientsModel> updateClient(
    String id,
    CreateClientRequest request,
  ) async {
    final response = await dio.put('/clients/$id', data: {request.toJson()});

    return ClientsModel.fromJson(response.data);
  }

  @override
  Future<List<ClientsModel>> getAllClients() async {
    final response = await dio.get("/clients/");

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response.data,
    );

    return data.map(ClientsModel.fromJson).toList();
  }
}
