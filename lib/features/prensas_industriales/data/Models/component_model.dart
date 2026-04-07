import '../../domain/entities/component_item.dart';

class PrensaComponentItem extends ComponentItem {
  PrensaComponentItem({
    required super.id,
    required super.name,
    required super.measureUnit,
    super.estado,
    super.quantity,
    super.observaciones,
  });

  // ESTE ES EL MÉTODO QUE BUSCA EL REPOSITORIO
  factory PrensaComponentItem.fromJson(Map<String, dynamic> json) {
    return PrensaComponentItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      measureUnit: json['measure_unit'] ?? 'PZA',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "component_id": id,
      "quantity": quantity,
      "state": estado == 0 ? "buena" : estado == 1 ? "mala" : "no_aplica",
      "observations": observaciones,
    };
  }
}