import 'dart:typed_data';

class EvidenceFile {
  final Uint8List bytes;
  final String type; 
  final String mimeType;

  EvidenceFile({required this.bytes, required this.type, required this.mimeType});
}

class ComponentItem {
  final String id;
  final String name;
  final String measureUnit;
  int? quantity;
  String status; //  (good, bad, not_applicable)
  String observation; 
  List<EvidenceFile> evidenceBefore;
  List<EvidenceFile> evidenceAfter;

  ComponentItem({
    required this.id,
    required this.name,
    required this.measureUnit,
    this.quantity,
    this.status = "not_applicable", // Valor inicial por defecto
    this.observation = '',
    List<EvidenceFile>? evidenceBefore,
    List<EvidenceFile>? evidenceAfter,
  }) : evidenceBefore = evidenceBefore ?? [],
       evidenceAfter = evidenceAfter ?? [];
} 