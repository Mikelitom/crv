// lib/core/models/prensa_inspection_model.dart
class PrensaComponentItem {
 final String unidad;
  final String descripcion;
  int? estado; // null: sin selección, 0: Bueno, 1: Malo, 2: N/A
  String cantidad;
  String observaciones;
  String? evidenciaPath;

  PrensaComponentItem({
   required this.unidad,
    required this.descripcion,
    this.estado,
    this.cantidad = "",
    this.observaciones = "",
    this.evidenciaPath,
  });
}