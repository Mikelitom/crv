import '../../domain/entities/clients_conveyor.dart';

class ClientsConveyorModel extends ClientsConveyor {
  ClientsConveyorModel({
    required super.id,
    required super.name,
    required super.company,
    required super.phone,
    required super.email,
    required super.createdAt,
    required super.updatedAt,
    required super.isActive,
  });
  factory ClientsConveyorModel.fromJson(Map<String, dynamic> json) {
    return ClientsConveyorModel(
      id: json['id'],
      name: json['name'],
      company: json['company'],
      phone: json['phone'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isActive: json['is_active'],
    );
  }
}

class MineModel extends Mine {
  MineModel({
    required super.id,
    required super.clientId,
    required super.name,
    required super.address,
    required super.email,
    required super.createdAt,
    required super.updatedAt,
    required super.isActive,
  });
  factory MineModel.fromJson(Map<String, dynamic> json) {
    return MineModel(
      id: json['id'],
      clientId: json['client_id'],
      name: json['name'],
      address: json['address'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isActive: json['is_active'],
    );
  }
}
