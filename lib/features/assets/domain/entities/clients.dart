class Clients {
  final String id;
  final String name;
  final String company;
  final String? phone;
  final String? email;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  Clients({
    required this.id,
    required this.name,
    required this.company,
    this.phone,
    this.email,
    required this.createdAt,
    this.updatedAt,
    required this.isActive,
  });
}

class Mine {
  final String id;
  final String clientId;
  final String name;
  final String? address;
  final String? phone;
  final String? email;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  Mine({
    required this.id,
    required this.clientId,
    required this.name,
    this.address,
    this.phone,
    this.email,
    required this.createdAt,
    this.updatedAt,
    required this.isActive,
  });
}
