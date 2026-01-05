// lib/core/models/prensa_inspection_model.dart
class PrensaComponentItem {
  final String unidad;
  final String descripcion;
  int? estado; // 0: Buena, 1: Mala, 2: N/A
  String observaciones;
  String cantidad;

  PrensaComponentItem({
    required this.unidad,
    required this.descripcion,
    this.estado,
    this.observaciones = "",
    this.cantidad = "",
  });
}