import 'dart:typed_data';

class BandaTemplate {
  final List<BandaSection> sections;
  BandaTemplate({required this.sections});
}

class BandaSection {
  final String id;
  final String name;
  final List<BandaComponent> components;

  BandaSection({required this.id, required this.name, required this.components});
}

class BandaComponent {
  final String id;
  final String name;
  final String? description;
  final List<BandaOption> options;
  
  // Campos de estado para la captura
  final String? selectedOptionId;
  final String dimension;
  final String observation;
  final List<EvidenceFile> evidenceBefore;
  final List<EvidenceFile> evidenceAfter;

  BandaComponent({
    required this.id,
    required this.name,
    this.description,
    required this.options,
    this.selectedOptionId,
    this.dimension = '0',
    this.observation = '',
    List<EvidenceFile>? evidenceBefore,
    List<EvidenceFile>? evidenceAfter,
  }) : evidenceBefore = evidenceBefore ?? [],
       evidenceAfter = evidenceAfter ?? [];

  // Método copyWith respetando tus nombres existentes
  BandaComponent copyWith({
    String? id,
    String? name,
    String? description,
    List<BandaOption>? options,
    String? selectedOptionId,
    String? dimension,
    String? observation,
    List<EvidenceFile>? evidenceBefore,
    List<EvidenceFile>? evidenceAfter,
  }) {
    return BandaComponent(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      options: options ?? this.options,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      dimension: dimension ?? this.dimension,
      observation: observation ?? this.observation,
      evidenceBefore: evidenceBefore ?? this.evidenceBefore,
      evidenceAfter: evidenceAfter ?? this.evidenceAfter,
    );
  }
}

class BandaOption {
  final String id;
  final String label;
  final String value;

  BandaOption({required this.id, required this.label, required this.value});
}

class EvidenceFile {
  final Uint8List bytes;
  final String type; // image
  final String mimeType;
  EvidenceFile({required this.bytes, required this.type, required this.mimeType});
}