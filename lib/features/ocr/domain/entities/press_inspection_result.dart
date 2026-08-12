enum PressAnswer { good, bad, none, invalid }

class PressInspectionAnswer {
  final int rowIndex;
  final PressAnswer answer;

  const PressInspectionAnswer({required this.rowIndex, required this.answer});
}
