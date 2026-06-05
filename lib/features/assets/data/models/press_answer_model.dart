import '../../domain/entities/press_answer_entity.dart';

class PressAnswerModel extends PressAnswerEntity {
  PressAnswerModel({
    required super.componentName,
    required super.quantity,
    required super.status,
    required super.observation,
    required super.evidencePaths,
    required super.measureUnit,
  });

  factory PressAnswerModel.fromJson(Map<String, dynamic> json) {
    final List<String> paths = (json['evidences'] as List<dynamic>?)
        ?.map((e) => e['signed_url']?.toString() ?? '')
        .where((url) => url.isNotEmpty)
        .toList() ?? [];

    return PressAnswerModel(
      componentName: json['component']?['name'] ?? 'Sin nombre',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      status: json['status'] ?? '',
      observation: json['observation'] ?? '',
      evidencePaths: paths,
      // AQUÍ ESTÁ LA DINAMICIDAD:
      measureUnit: json['component']?['measure_unit'] ?? 'PZA',
    );
  }
}