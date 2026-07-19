import 'package:crv_reprosisa/features/prensas_industriales/domain/entities/component_item.dart';

class PrensaComponentItem extends ComponentItem {
  PrensaComponentItem({
    required super.id,
    required super.name,
    required super.measureUnit,
    super.quantity,
    super.status,
    super.observation,
    // Aseguramos que el constructor acepte estos parámetros nombrados
    super.evidenceBefore,
    super.evidenceAfter,
  });

  factory PrensaComponentItem.fromJson(Map<String, dynamic> json) {
    return PrensaComponentItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      measureUnit: json['measure_unit'] ?? 'PZA',
      quantity: json['quantity'] ?? 0,
      status: json['status'] ?? '', 
      observation: json['observation'] ?? '',
    );
  }

  PrensaComponentItem copyWith({
    int? quantity,
    String? status,
    String? observation,
    List<EvidenceFile>? evidenceBefore, // Añadido aquí
    List<EvidenceFile>? evidenceAfter,  // Añadido aquí
  }) {
    return PrensaComponentItem(
      id: this.id,
      name: this.name,
      measureUnit: this.measureUnit,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      observation: observation ?? this.observation,
      evidenceBefore: evidenceBefore ?? this.evidenceBefore,
      evidenceAfter: evidenceAfter ?? this.evidenceAfter,
    );
  }

  Map<String, dynamic> toAnswerJson(List<Map<String, String>> uploadedEvidences) {
    return {
      "component_id": id,
      "quantity": quantity ?? 0,
      "status": status, 
      "observation": observation,
      "evidences": uploadedEvidences, 
    };
  }
}