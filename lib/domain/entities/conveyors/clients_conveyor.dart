class ClientsConveyor {
  final String id;
  final String name;
  final String company;
  final String phone;
  final String email;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String is_active;

  ClientsConveyor({
    required this.id,
    required this.name,
    required this.company,
    required this.phone,
    required this.email,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.is_active,
  });
}