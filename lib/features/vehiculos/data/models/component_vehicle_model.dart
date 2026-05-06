import 'dart:typed_data';

class EvidenceFile {
  final Uint8List bytes;
  final String type; 
  final String mimeType;

  EvidenceFile({required this.bytes, required this.type, required this.mimeType});
}

class ComponentVehicleModel {
  final String id; // component_id (UUID)
  final String description;
  String? selectedOptionId; // UUID de la opción (good, bad, etc.)
  String observations;
  List<EvidenceFile> evidences;

  ComponentVehicleModel({
    required this.id,
    required this.description,
    this.selectedOptionId,
    this.observations = "",
    List<EvidenceFile>? evidences,
  }) : evidences = evidences ?? [];
}