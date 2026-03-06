enum AssetType { vehicle, press }

class ClienteModelActivo {
  final String id;
  final String nombreCompleto;
  final String empresa;
  final String telefono;
  final String email;
  final String direccion;

  ClienteModelActivo({
    required this.id,
    required this.nombreCompleto,
    required this.empresa,
    required this.telefono,
    required this.email,
    required this.direccion,
  });
}

class VehiculoModelActivo {
  final String id;
  final String tipo;
  final String modelo;
  final String marca;
  final String placa;     
  final String ano;       


  VehiculoModelActivo({
    required this.id,
    required this.tipo,
    required this.modelo,
    required this.marca,
    this.placa = '',
    this.ano = '',   
  });
}

class PrensaModelActivo{
  final String id;
  final String tipo;
  final String modelo;
  final String volts;
  final String serie;
  final String size;

  PrensaModelActivo({
    required this.id,
    required this.tipo,
    required this.modelo,
    required this.volts,
    required this.serie,
    required this.size,
  });
}
