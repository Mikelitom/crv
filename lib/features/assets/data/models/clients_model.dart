import '../../domain/entities/clients.dart';

class ClientsModel extends Clients {
  ClientsModel({
    required super.id,
    required super.name,
    required super.company,
    required super.phone,
    required super.email,
    required super.createdAt,
    required super.updatedAt,
    required super.isActive,
  });

  factory ClientsModel.fromJson(Map<String, dynamic> json) {
    return ClientsModel(
      id: json['id'],
      name: json['name'],
      company: json['company'],
      phone: json['phone'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      isActive: json['is_active'],
    );
  }

  Clients toEntity() {
    return Clients(
      id: id,
      name: name,
      company: company,
      phone: phone,
      email: email,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
    );
  }
}

class MineModel extends Mine {
  MineModel({
    required super.id,
    required super.clientId,
    required super.name,
    required super.address,
    required super.phone,
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
      phone: json['phone'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      isActive: json['is_active'],
    );
  }

  Mine toEntity() {
    return Mine(
      id: id,
      clientId: clientId,
      name: name,
      address: address,
      phone: phone,
      email: email,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
    );
  }
}
