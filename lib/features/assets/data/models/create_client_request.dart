import 'package:crv_reprosisa/features/assets/data/models/create_mine_request.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';

class CreateClientRequest {
  final String id; // AÑADIDO: Requerido por el cuerpo del PUT
  final String name;
  final String company;
  final String? phone;
  final String? email;
  final List<CreateMineRequest> mines;

  const CreateClientRequest({
    required this.id, 
    required this.name,
    required this.company,
    this.phone,
    this.email,
    required this.mines,
  });

  factory CreateClientRequest.fromParams(CreateClientParams params, {String? id}) {
    return CreateClientRequest(
      id: id ?? '', // Si es creación nueva, puedes pasar ""
      name: params.name,
      company: params.company,
      phone: params.phone,
      email: params.email, 
      mines: params.mines.map((m) => CreateMineRequest.fromParams(m)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Se envía el ID para la actualización
      'name': name,
      'company': company,
      'phone': phone,
      'email': email,
      'mines': mines.map((e) => e.toJson()).toList(),
    };
  }
}