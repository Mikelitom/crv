import '../../domain/entities/clients.dart';

class ClientsModel extends Clients {
  ClientsModel({
    required super.id,
    required super.name,
    required super.company,
    required super.phone,
    required super.email,
    required super.createdAt,
    super.updatedAt,
    required super.isActive,
    super.mines, // Ahora aceptamos minas
  });

  factory ClientsModel.fromJson(Map<String, dynamic> json) {
    return ClientsModel(
      id: json['client_id']?.toString() ?? '', 
      name: json['name']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      // El JSON no trae createdAt/updatedAt para el cliente principal, 
      // si los necesitas, ajústalos aquí. Si no, usamos DateTime.now()
      createdAt: DateTime.now(), 
      isActive: json['is_active'] ?? true,
      // Mapeo de la lista de minas que viene en el JSON
      mines: (json['mines'] as List?)
          ?.map((m) => MineModel.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MineModel extends Mine {
  MineModel({
    required super.id,
    required super.clientId,
    required super.name,
    super.address,
    super.phone,
    super.email,
    required super.isActive,
    required super.createdAt,
  });

  factory MineModel.fromJson(Map<String, dynamic> json) {
    return MineModel(
      id: json['id']?.toString() ?? '',
      clientId: json['client_id']?.toString() ?? '', // Si lo recibes en la mina
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }
}