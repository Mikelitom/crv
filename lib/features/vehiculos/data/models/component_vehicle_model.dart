import 'dart:typed_data';

class EvidenceFile {
  final Uint8List bytes;
  final String type; 
  final String mimeType;

  EvidenceFile({required this.bytes, required this.type, required this.mimeType});
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
}