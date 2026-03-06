class CreateClientParams {
  final String name;
  final String company;
  final String? phone;
  final String email;
  final String address;

  const CreateClientParams({
    required this.name,
    required this.company,
    this.phone,
    required this.email,
    required this.address,
  });
}
