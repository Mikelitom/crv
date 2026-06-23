import '../../domain/entities/roller.dart';

class RollerModel extends Roller {
  RollerModel({
    required super.tableNumber,
    required super.baseNumber,
    required super.isLeft,
    required super.isCenter,
    required super.isRight,
    required super.isImpact,
    required super.isReturn,
    required super.isTriple,
    required super.isSelfAligning,
    required super.observation, // Campo nuevo
  });

  factory RollerModel.fromJson(Map<String, dynamic> json) => RollerModel(
    tableNumber: json['table_number'] ?? 0,
    baseNumber: json['base_number'] ?? 0,
    isLeft: json['is_left'] ?? false,
    isCenter: json['is_center'] ?? false,
    isRight: json['is_right'] ?? false,
    isImpact: json['is_impact'] ?? false,
    isReturn: json['is_return'] ?? false,
    isTriple: json['is_triple'] ?? false,
    isSelfAligning: json['is_self_aligning'] ?? false,
    observation: json['observation'] ?? '', // Mapeo del campo nuevo
  );

  Map<String, dynamic> toJson() => {
    'table_number': tableNumber,
    'base_number': baseNumber,
    'is_left': isLeft,
    'is_center': isCenter,
    'is_right': isRight,
    'is_impact': isImpact,
    'is_return': isReturn,
    'is_triple': isTriple,
    'is_self_aligning': isSelfAligning,
    'observation': observation, // Serialización del campo nuevo
  };
}