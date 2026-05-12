import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';

class CreateMineRequest {
  final String name;
  final String? address;
  final String? phone;
  final String? email;

  const CreateMineRequest({
    required this.name,
    this.address,
    this.phone,
    this.email,
  });

  factory CreateMineRequest.fromParams(CreateMineParams params) {
    return CreateMineRequest(
      name: params.name,
      address: params.address,
      phone: params.phone,
      email: params.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'address': address, 'phone': phone, 'email': email};
  }
}
