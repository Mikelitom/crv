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
