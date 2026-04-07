import 'dart:typed_data'; 

class ComponentItem {
  final String id;
  final String name;
  final String measureUnit;
  int? quantity;
  int estado; 
  String observaciones;
  List<Uint8List> evidences; 

  ComponentItem({
    required this.id,
    required this.name,
    required this.measureUnit,
    this.quantity,
    this.estado = 2,
    this.observaciones = '',
    List<Uint8List>? evidences,
  }) : evidences = evidences ?? [];
}