class Press {
  final String id;
  final String serie;
  final String? model;
  final String? voltz;
  final String? type;

  Press({
    required this.id,
    required this.serie,
    this.model,
    this.voltz,
    this.type,
  });

 factory Press.fromJson(Map<String, dynamic> json) {
    return Press(
      id: json['id']?.toString() ?? '',
      serie: json['serie']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      voltz: json['voltz']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }
}