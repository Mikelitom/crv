class Clients {
  final String id; // Será mapeado desde 'client_id'
  final String name;
  final String company;
  final String? phone;
  final String? email;
  final DateTime createdAt; // Se usará para registro temporal si no viene
  final DateTime? updatedAt;
  final bool isActive;
  final List<Mine>? mines; // Lista de minas anidada

  Clients({
    required this.id,
    required this.name,
    required this.company,
    this.phone,
    this.email,
    required this.createdAt,
    this.updatedAt,
    required this.isActive,
    this.mines,
  });
}

class Mine {
  final String id;
  final String clientId;
  final String name;
  final String? address;
  final String? phone;
  final String? email;
  final bool isActive;
  final DateTime createdAt; 

  Mine({
    required this.id,
    required this.clientId,
    required this.name,
    this.address,
    this.phone,
    this.email,
    required this.isActive,
    required this.createdAt,
  });
}