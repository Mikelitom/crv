import '../../domain/entities/banda_template.dart';

class BandaOptionModel extends BandaOption {
  BandaOptionModel({required super.id, required super.label, required super.value});

  factory BandaOptionModel.fromJson(Map<String, dynamic> json) => BandaOptionModel(
    id: json['id'],
    label: json['label'],
    value: json['value'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'value': value,
  };
}

class BandaComponentModel extends BandaComponent {
  BandaComponentModel({
    required super.id,
    required super.name,
    super.description,
    required List<BandaOptionModel> super.options,
  });

  factory BandaComponentModel.fromJson(Map<String, dynamic> json) => BandaComponentModel(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    options: (json['options'] as List).map((e) => BandaOptionModel.fromJson(e)).toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'options': options.map((e) => (e as BandaOptionModel).toJson()).toList(),
  };
}

class BandaSectionModel extends BandaSection {
  BandaSectionModel({required super.id, required super.name, required List<BandaComponentModel> super.components});

  factory BandaSectionModel.fromJson(Map<String, dynamic> json) => BandaSectionModel(
    id: json['id'],
    name: json['name'],
    components: (json['components'] as List).map((e) => BandaComponentModel.fromJson(e)).toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'components': components.map((e) => (e as BandaComponentModel).toJson()).toList(),
  };
}