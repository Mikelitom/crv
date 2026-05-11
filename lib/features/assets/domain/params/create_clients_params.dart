class CreateClientParams {
  final String name;
  final String company;
  final String? phone;
  final String email;

  const CreateClientParams({
    required this.name,
    required this.company,
    this.phone,
    required this.email,
  });
}

class CreateMineParams {
  final String clientId;
  final String name;
  final String? address;
  final String? phone;
  final String? email;

  const CreateMineParams({
    required this.clientId,
    required this.name,
    this.address,
    this.phone,
    this.email,
  });
}
