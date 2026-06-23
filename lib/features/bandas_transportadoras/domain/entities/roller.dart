class Roller {
  final int tableNumber;
  final int baseNumber;
  final bool isLeft;
  final bool isCenter;
  final bool isRight;
  final bool isImpact;
  final bool isReturn;
  final bool isTriple;
  final bool isSelfAligning;
  final String observation; 

  Roller({
    required this.tableNumber,
    required this.baseNumber,
    required this.isLeft,
    required this.isCenter,
    required this.isRight,
    required this.isImpact,
    required this.isReturn,
    required this.isTriple,
    required this.isSelfAligning,
    required this.observation,
  });
}