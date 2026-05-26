class CreateClientParams {
  final String name;
  final String company;
  final String? phone;
  final String? email;
  final List<CreateMineParams> mines;

  const CreateClientParams({
    required this.name,
    required this.company,
    this.phone,
    this.email,
    required this.mines,
  });
}

class CreateMineParams {
  final String? id; 
  final String name;
  final String? address;
  final String? phone;
  final String? email;
  final bool isActive; // <--- AGREGADO: Para controlar el estado lógico

  const CreateMineParams({
    this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    this.isActive = true, // Por defecto, al crear, está activa
  });

  /// Método actualizado para incluir el estado de activación
  CreateMineParams copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    bool? isActive, // <--- AGREGADO
  }) {
    return CreateMineParams(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
    );
  }
}