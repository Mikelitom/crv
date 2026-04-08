class PrensaComponentItem {
 final String unidad;
  final String descripcion;
  int? estado; 
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