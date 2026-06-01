import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';

class CreateMineRequest {
  final String? id;    
  final String? clientId; 
  final String name;
  final String? address;
  final String? phone;
  final String? email;

  const CreateMineRequest({
    this.id, 
    this.clientId,
    required this.name,
    this.address,
    this.phone,
    this.email,
  });

  factory CreateMineRequest.fromParams(CreateMineParams params, {String? clientId}) {
    return CreateMineRequest(
      id: params.id, // Directamente asignamos el id desde los params
      clientId: clientId,
      name: params.name,
      address: params.address,
      phone: params.phone,
      email: params.email,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
    };

    // Solo añadimos el ID al mapa si existe y no está vacío.
    // Si es null o "", no se incluirá en el JSON, y FastAPI tomará el valor default (None).
    if (id != null && id!.isNotEmpty) {
      data['id'] = id;
    }
    
    // Lo mismo para el clientId
    if (clientId != null && clientId!.isNotEmpty) {
      data['client_id'] = clientId;
    }

    return data;
  } 
}