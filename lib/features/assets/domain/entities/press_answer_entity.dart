import 'dart:typed_data'; // Importante

class PressAnswerEntity {
  // ... tus campos existentes ...
  final String componentName;
  final int quantity;
  final String status;
  final String observation;
  final List<String> evidencePaths;
  final String measureUnit;
  
  // NUEVO: Campo para los bytes
  Uint8List? evidenceBytes; 

  PressAnswerEntity({
    required this.componentName,
    required this.quantity,
    required this.status,
    required this.observation,
    required this.evidencePaths,
    required this.measureUnit,
    this.evidenceBytes, // Añadir al constructor
  });
}