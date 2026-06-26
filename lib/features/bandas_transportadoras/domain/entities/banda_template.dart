import 'dart:typed_data';

class BandaTemplate {
  final List<BandaSection> sections;
  BandaTemplate({required this.sections});

  BandaTemplate copyWith({List<BandaSection>? sections}) {
    return BandaTemplate(sections: sections ?? this.sections);
  }

  Map<String, dynamic> toJson() => {
    'sections': sections.map((e) => e.toJson()).toList(),
  };
}

class BandaSection {
  final String id;
  final String name;
  final List<BandaComponent> components;

  BandaSection({required this.id, required this.name, required this.components});

  BandaSection copyWith({
    String? id,
    String? name,
    List<BandaComponent>? components,
  }) {
    return BandaSection(
      id: id ?? this.id,
      name: name ?? this.name,
      components: components ?? this.components,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'components': components.map((e) => e.toJson()).toList(),
  };
}

class BandaComponent {
  final String id;
  final String name;
  final String? description;
  final List<BandaOption> options;
  final List<String> customOptions;  
  final List<String> selectedOptionIds; 
  final String dimentions;
  final String observation;
  final String comment; 
  final List<EvidenceFile> evidenceBefore;
  final List<EvidenceFile> evidenceAfter;

  BandaComponent({
    required this.id,
    required this.name,
    this.description,
    required this.options,
    this.customOptions = const [],
    this.selectedOptionIds = const [],
    required this.dimentions, // Eliminé el = '', ahora es obligatorio pasarlo
    this.observation = '',
    this.comment = '', 
    List<EvidenceFile>? evidenceBefore,
    List<EvidenceFile>? evidenceAfter,
  }) : evidenceBefore = evidenceBefore ?? [],
       evidenceAfter = evidenceAfter ?? [];

  BandaComponent copyWith({
    String? id, String? name, String? description,
    List<BandaOption>? options, List<String>? customOptions, 
    List<String>? selectedOptionIds, String? dimentions,
String? comment, 
    String? observation, List<EvidenceFile>? evidenceBefore,
    List<EvidenceFile>? evidenceAfter,
  }) {
    return BandaComponent(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      options: options ?? this.options,
      customOptions: customOptions ?? this.customOptions,
      selectedOptionIds: selectedOptionIds ?? this.selectedOptionIds,
      dimentions: dimentions ?? this.dimentions,
      observation: observation ?? this.observation,
      comment: comment ?? this.comment,
      evidenceBefore: evidenceBefore ?? this.evidenceBefore,
      evidenceAfter: evidenceAfter ?? this.evidenceAfter,
    );
  }

  Map<String, dynamic> toJson() {
    final fixedIds = selectedOptionIds
        .where((val) => options.any((o) => o.id == val && o.id != o.value))
        .toList();
    final customLabels = selectedOptionIds
        .where((val) => !options.any((o) => o.id == val))
        .toList();
        
    return {
      'accesory_id': id,
      'name': name,
      'description': description,
      'options': options.map((e) => e.toJson()).toList(),
      'selected_option_ids': fixedIds,
      'custom_options': customLabels,
      'dimentions': dimentions,
      'recommended_action': observation,
    };
  }
}

class BandaOption {
  final String id;
  final String label;
  final String value;

  BandaOption({required this.id, required this.label, required this.value});

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'value': value,
  };
}

class EvidenceFile {
  final Uint8List bytes;
  final String type;
  final String mimeType;
  EvidenceFile({required this.bytes, required this.type, required this.mimeType});
}