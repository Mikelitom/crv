import '../../domain/entities/client_mine.dart';

class ClientModel extends Client {
  ClientModel({required super.id, required super.name, required super.company});

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
    id: json['id'],
    name: json['name'],
    company: json['company'],
  );
}

class MineModel extends Mine {
  MineModel({required super.id, required super.clientId, required super.name, required super.address});

  factory MineModel.fromJson(Map<String, dynamic> json) => MineModel(
    id: json['id'],
    clientId: json['client_id'],
    name: json['name'],
    address: json['address'],
  );
}