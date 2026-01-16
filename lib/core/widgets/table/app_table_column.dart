class AppTableColumn<T> {
  final String label;
  final double? width;
  final bool isNumeric;

  const AppTableColumn({
    required this.label,
    this.width,
    this.isNumeric = false,
  });
}