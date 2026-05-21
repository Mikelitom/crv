import 'package:crv_reprosisa/features/assets/data/models/create_mine_request.dart';
import '../../domain/params/create_clients_params.dart';

class CreateClientRequest {
  final String name;
  final String company;
  final String? phone;
  final String? email;
  final List<CreateMineRequest> mines;

  const CreateClientRequest({
    required this.name,
    required this.company,
    this.phone,
    this.email,
    required this.mines,
  });

  factory CreateClientRequest.fromParams(CreateClientParams params) {
    return CreateClientRequest(
      name: params.name,
      company: params.company,
      phone: params.phone,
      mines: params.mines.map(CreateMineRequest.fromParams).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'company': company,
      'phone': phone,
      'email': email,
      'mines': mines.map((e) => e.toJson()).toList(),
    };
  }
}
