import '../../domain/entities/component_item.dart';

class PrensaComponentItem extends ComponentItem {
  PrensaComponentItem({
    required super.id,
    required super.name,
    required super.measureUnit,
    super.quantity,
    super.status = "not_applicable",
    super.observation = '',
    super.evidenceBefore,
    super.evidenceAfter,
  });

  // Este es el método que usa el repositorio para mapear lo que viene de la BD/API
  factory PrensaComponentItem.fromJson(Map<String, dynamic> json) {
    return PrensaComponentItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      // Usamos el nombre del campo que viene de tu DB (measure_unit)
      measureUnit: json['measure_unit'] ?? 'PZA', 
      // Por defecto los componentes nuevos vienen en not_applicable y sin observación
      status: json['status'] ?? "not_applicable",
      observation: json['observation'] ?? '',
    );
  }

  // Método para convertir el objeto a JSON para el POST a la API de Python
  Map<String, dynamic> toJson() {
    return {
      "component_id": id,
      "quantity": quantity ?? 0,
      "status": status, // Ya es string: "good", "bad", "not_applicable"
      "observation": observation, // Nombre exacto que pide tu esquema
      // Nota: Las evidencias se suelen procesar en el Service/Provider 
      // antes de enviar el JSON final, pero puedes mapearlas aquí si fuera necesario.
      "evidences": [], 
    };
  }
}