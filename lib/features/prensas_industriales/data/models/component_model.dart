import '../../domain/entities/component_item.dart';

class PrensaComponentItem extends ComponentItem {
  PrensaComponentItem({
    required super.id,
    required super.name,
    required super.measureUnit,
    super.quantity,
    super.status,
    super.observation,
    super.evidenceBefore,
    super.evidenceAfter,
  });

  factory PrensaComponentItem.fromJson(Map<String, dynamic> json) {
    return PrensaComponentItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      measureUnit: json['measure_unit'] ?? 'PZA',
      quantity: 0,
      status: '', 
      observation: '',
    );
  }

  Map<String, dynamic> toAnswerJson(List<Map<String, String>> uploadedEvidences) {
    return {
      "component_id": id,
      "quantity": quantity ?? 0,
      "status": status, // "good", "bad", "not_applicable"
      "observation": observation,
      "evidences": uploadedEvidences, // Aquí pasamos los DTOs ya subidos
    };
  }
}