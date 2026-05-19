class CreateClientParams {
  final String name;
  final String company;
  final String? phone;
  final String email;
  final String? rfc; // <-- Nuevo campo RFC
  final List<CreateMineParams> mines;

  const CreateClientParams({
    required this.name,
    required this.company,
    this.phone,
    required this.email,
    this.rfc, // <-- Agregado al constructor
    required this.mines,
  });
}

class CreateMineParams {
  final String name;
  final String? address;
  final String? phone;
  final String? email;

  const CreateMineParams({
    required this.name,
    this.address,
    this.phone,
    this.email,
  });
}
