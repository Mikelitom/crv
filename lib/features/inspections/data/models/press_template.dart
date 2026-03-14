import 'package:crv_reprosisa/features/inspections/data/models/component_press_model.dart';
import 'package:crv_reprosisa/features/inspections/domain/entities/press_template.dart';

class PressTemplateModel extends PressTemplate {
  PressTemplateModel({required super.components, required super.options});

  factory PressTemplateModel.fromJson(Map<String, dynamic> json) {
    return PressTemplateModel(
      components: (json['components'] as List)
          .map((e) => ComponentPressModel.fromJson(e))
          .toList(),
      options: List<String>.from(json['status_options']),
    );
  }
}
