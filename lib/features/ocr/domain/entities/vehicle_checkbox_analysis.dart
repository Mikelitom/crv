import 'package:crv_reprosisa/features/ocr/domain/entities/checkbox_analysis.dart';

class VehicleCheckboxAnalysis {
  final CheckboxAnalysis good;
  final CheckboxAnalysis bad;
  final CheckboxAnalysis reposition;
  final CheckboxAnalysis repair;

  const VehicleCheckboxAnalysis({
    required this.good,
    required this.bad,
    required this.reposition,
    required this.repair,
  });

  String get highestOption {
    final values = {
      'GOOD': good.darkPixelRatio,
      'BAD': bad.darkPixelRatio,
      'REPOSITION': reposition.darkPixelRatio,
      'REPAIR': repair.darkPixelRatio,
    };

    return values.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  double get highestValue {
    final values = [
      good.darkPixelRatio,
      bad.darkPixelRatio,
      reposition.darkPixelRatio,
      repair.darkPixelRatio,
    ];

    return values.reduce((a, b) => a >= b ? a : b);
  }
}
