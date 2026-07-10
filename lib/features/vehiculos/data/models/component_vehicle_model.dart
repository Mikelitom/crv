import 'dart:typed_data';
class EvidenceFile {
  final Uint8List bytes;
  final String type;
  final String mimeType;
  
  // AQUÍ ES DONDE DEBES AGREGAR:
  final String? path; 

  EvidenceFile({
    required this.bytes,
    required this.type,
    required this.mimeType,
    this.path, // <--- Y AQUÍ EN EL CONSTRUCTOR
  });
}

class ComponentVehicleModel {
  final String id; 
  final String description;
  String? selectedOptionId; // UUID de la opción (good, bad, etc.)
  String observations;
  List<EvidenceFile> evidenceBefore;
  List<EvidenceFile> evidenceAfter;

  ComponentVehicleModel({
    required this.id,
    required this.description,
    this.selectedOptionId,
    this.observations = "",
    List<EvidenceFile>? evidenceBefore,
    List<EvidenceFile>? evidenceAfter,
  }) : evidenceBefore = evidenceBefore ?? [],
       evidenceAfter = evidenceAfter ?? [];

  // MÈTODO COPYWITH AGREGADO
  ComponentVehicleModel copyWith({
    String? id,
    String? description,
    String? selectedOptionId,
    String? observations,
    List<EvidenceFile>? evidenceBefore,
    List<EvidenceFile>? evidenceAfter,
  }) {
    return ComponentVehicleModel(
      id: id ?? this.id,
      description: description ?? this.description,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      observations: observations ?? this.observations,
      evidenceBefore: evidenceBefore ?? this.evidenceBefore,
      evidenceAfter: evidenceAfter ?? this.evidenceAfter,
    );
  }
}