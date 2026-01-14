enum UserStatus { activo, inactivo }
enum UserRole { administrador, adminArea, empleado }

class UsuarioModel {
  final String id;
  final String nombreCompleto;
  final String email;
  final String telefono;
  final UserRole tipo;
  final String areaTrabajo;
  final UserStatus estado;
  final DateTime ultimoAcceso;

  UsuarioModel({
    required this.id,
    required this.nombreCompleto,
    required this.email,
    required this.telefono,
    required this.tipo,
    required this.areaTrabajo,
    this.estado = UserStatus.activo,
    required this.ultimoAcceso,
  });
}