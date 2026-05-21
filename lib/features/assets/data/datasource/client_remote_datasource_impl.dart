import 'package:crv_reprosisa/features/assets/data/datasource/client_remote_datasource.dart';
import 'package:crv_reprosisa/features/assets/data/models/create_client_request.dart';
import 'package:crv_reprosisa/features/assets/data/models/clients_model.dart';
import 'package:dio/dio.dart';

class ClientRemoteDatasourceImpl implements ClientRemoteDatasource {
  final Dio dio;

  ClientRemoteDatasourceImpl(this.dio);

  @override
  Future<ClientsModel> createClient(CreateClientRequest request) async {
    // Usamos el endpoint para crear cliente + minas
    final response = await dio.post('/clients/mines', data: request.toJson());

    return ClientsModel.fromJson(response.data);
  }

  @override
  Future<ClientsModel> updateClient(
    String id,
    CreateClientRequest request,
  ) async {
    // Aseguramos que el cuerpo esté bien estructurado para el put
    final response = await dio.put('/clients/$id', data: request.toJson());

    return ClientsModel.fromJson(response.data);
  }

  @override
  Future<List<ClientsModel>> getAllClients() async {
    final response = await dio.get("/asset/clients");

    final List<dynamic> data = response.data as List<dynamic>;

    return data.map((json) => ClientsModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}