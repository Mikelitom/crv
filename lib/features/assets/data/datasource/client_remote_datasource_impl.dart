import 'package:crv_reprosisa/features/assets/data/datasource/client_remote_datasource.dart';
import 'package:crv_reprosisa/features/assets/data/models/clients_conveyor_model.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';
import 'package:dio/dio.dart';

class ClientRemoteDatasourceImpl implements ClientRemoteDatasource {
  final Dio dio;

  ClientRemoteDatasourceImpl(this.dio);

  @override
  Future<ClientsConveyorModel> createClient(CreateClientParams params) async {
    final response = await dio.post(
      '/clients/',
      data: {
        "name": params.name,
        "company": params.company,
        "phone": params.phone,
        "email": params.email,
        "address": params.address,
      },
    );

    return ClientsConveyorModel.fromJson(response.data);
  }

  @override
  Future<ClientsConveyorModel> updateClient(
    String id,
    CreateClientParams params,
  ) async {
    final response = await dio.put(
      '/clients/$id',
      data: {
        "name": params.name,
        "company": params.company,
        "phone": params.phone,
        "email": params.email,
        "address": params.address,
      },
    );

    return ClientsConveyorModel.fromJson(response.data);
  }

  @override
  Future<List<ClientsConveyorModel>> getAllClients() async {
    final response = await dio.get("/clients/");

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response.data,
    );

    return data.map(ClientsConveyorModel.fromJson).toList();
  }
}
