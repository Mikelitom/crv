import 'dart:typed_data';

class EvidenceFile {
  final Uint8List bytes;
  final String type; // 'image' o 'video'
  final String mimeType;

  EvidenceFile({required this.bytes, required this.type, required this.mimeType});
}

class ComponentItem {
  final String id;
  final String name;
  final String measureUnit;
  int? quantity;
  String status; // Se inicializa vacío: ''
  String observation;
  List<EvidenceFile> evidenceBefore;
  List<EvidenceFile> evidenceAfter;

  ComponentItem({
    required this.id,
    required this.name,
    required this.measureUnit,
    this.quantity = 0,
    this.status = '', // <--- SIN STATUS PREDETERMINADO
    this.observation = '',
    List<EvidenceFile>? evidenceBefore,
    List<EvidenceFile>? evidenceAfter,
  })  : evidenceBefore = evidenceBefore ?? [],
        evidenceAfter = evidenceAfter ?? [];

  factory ComponentItem.fromJson(Map<String, dynamic> json) {
    return ComponentItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      measureUnit: json['measure_unit'] ?? 'PZA',
    );
  }
}