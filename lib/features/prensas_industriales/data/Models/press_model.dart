import '../../domain/entities/entities_press.dart';

class PressModel extends Press {
  PressModel({
    required super.id,
    required super.serie,
    super.model,
    super.voltz,
    super.type,
  });

  factory PressModel.fromJson(Map<String, dynamic> json) {
    return PressModel(
      id: json['id'],
      serie: json['serie'],
      model: json['model'],
      voltz: json['voltz'],
      type: json['type'],
    );
  }
}