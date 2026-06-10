class ConveyorReportDetail {
  final Map<String, dynamic> report;
  final Map<String, dynamic> conveyor;
  final Map<String, dynamic> version;
  final Map<String, dynamic> inspector;
  final List<Answer> answers;

  ConveyorReportDetail({
    required this.report,
    required this.conveyor,
    required this.version,
    required this.inspector,
    required this.answers,
  });

  factory ConveyorReportDetail.fromJson(Map<String, dynamic> json) {
    return ConveyorReportDetail(
      report: json['report'] as Map<String, dynamic>? ?? {},
      conveyor: json['conveyor'] as Map<String, dynamic>? ?? {},
      version: json['version'] as Map<String, dynamic>? ?? {},
      inspector: json['inspector'] as Map<String, dynamic>? ?? {},
      answers: (json['answers'] as List<dynamic>?)
              ?.map((a) => Answer.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() => {
        'report': report,
        'conveyor': conveyor,
        'version': version,
        'inspector': inspector,
        'answers': answers.map((a) => a.toMap()).toList(),
      };
}

class Answer {
  final String answerId;
  final ReportSection section;
  final Accessory accessory;
  final ReportOption option;
  final String recommendedAction;
  final double dimensions;
  final List<Evidence> evidences;

  Answer({
    required this.answerId,
    required this.section,
    required this.accessory,
    required this.option,
    required this.recommendedAction,
    required this.dimensions,
    required this.evidences,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answerId: json['answer_id'] as String? ?? '',
      section: ReportSection.fromJson(json['section'] as Map<String, dynamic>? ?? {}),
      accessory: Accessory.fromJson(json['accesory'] as Map<String, dynamic>? ?? {}),
      option: ReportOption.fromJson(json['option'] as Map<String, dynamic>? ?? {}),
      recommendedAction: json['recommended_action'] as String? ?? '',
      dimensions: (json['dimentions'] as num?)?.toDouble() ?? 0.0,
      evidences: (json['evidences'] as List<dynamic>?)
              ?.map((e) => Evidence.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() => {
        'answer_id': answerId,
        'section': section.toMap(),
        'accesory': accessory.toMap(),
        'option': option.toMap(),
        'recommended_action': recommendedAction,
        'dimentions': dimensions,
        'evidences': evidences.map((e) => e.toMap()).toList(),
      };
}

class ReportSection {
  final String id;
  final String name;

  ReportSection({required this.id, required this.name});

  factory ReportSection.fromJson(Map<String, dynamic> json) {
    return ReportSection(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {'id': id, 'name': name};
}

class Accessory {
  final String id;
  final String name;
  final String description;

  Accessory({required this.id, required this.name, required this.description});

  factory Accessory.fromJson(Map<String, dynamic> json) {
    return Accessory(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'description': description};
}

class ReportOption {
  final String id;
  final String label;
  final String value;

  ReportOption({required this.id, required this.label, required this.value});

  factory ReportOption.fromJson(Map<String, dynamic> json) {
    return ReportOption(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {'id': id, 'label': label, 'value': value};
}

class Evidence {
  final String id;
  final String filePath;
  final String signedUrl;
  final String fileType;
  final String mimeType;
  final int fileSize;

  Evidence({
    required this.id,
    required this.filePath,
    required this.signedUrl,
    required this.fileType,
    required this.mimeType,
    required this.fileSize,
  });

  factory Evidence.fromJson(Map<String, dynamic> json) {
    return Evidence(
      id: json['id'] as String? ?? '',
      filePath: json['file_path'] as String? ?? '',
      signedUrl: json['signed_url'] as String? ?? '',
      fileType: json['file_type'] as String? ?? '',
      mimeType: json['mime_type'] as String? ?? '',
      fileSize: json['file_size'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'file_path': filePath,
        'signed_url': signedUrl,
        'file_type': fileType,
        'mime_type': mimeType,
        'file_size': fileSize,
      };
}