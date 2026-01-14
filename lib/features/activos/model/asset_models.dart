enum AssetType { vehicle, press }

class ClienteModel {
  final String id;
  final String nombreCompleto;
  final String empresa;
  final String telefono;
  final String email;
  final String direccion;
  final List<String> minasRelacionadas; // Relación dinámica con minas

  ClienteModel({
    required this.id,
    required this.nombreCompleto,
    required this.empresa,
    required this.telefono,
    required this.email,
    required this.direccion,
    this.minasRelacionadas = const [],
  });
}

class ActivoModel {
  final String id;
  final String marca;
  final String modelo;
  final String serie;
  final String capacidad; // Solo para prensas
  final AssetType tipo;
  final String idClienteOwner;
  final String minaUbicacion;

  ActivoModel({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.serie,
    this.capacidad = '',
    required this.tipo,
    required this.idClienteOwner,
    required this.minaUbicacion,
  });
}