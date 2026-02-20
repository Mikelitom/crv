import 'package:crv_reprosisa/domain/entities/conveyors/clients_conveyor.dart';

class ClientsConveyorModel extends ClientsConveyor{
  ClientsConveyorModel({
    required super.id,
    required super.name,
    required super.company,
    required super.phone,
    required super.email,
    required super.address,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active,
  });
   factory ClientsConveyorModel.fromJson(Map<String, dynamic> json) {
    return ClientsConveyorModel(
      id: json['id'],
      name: json['name'],
      company: json['company'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],

    );
  }
}