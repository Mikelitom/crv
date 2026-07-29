import '../../domain/entities/press.dart';

class PressModel extends Press {
  PressModel({
    required super.id,
    required super.type,
    required super.model,
    required super.volts,
    required super.serie,
    required super.size,
    required super.isActive,
    required super.operationState,
    super.currentLocation,
    super.responsible,
    super.loanComment,
    super.serviceReason,
    super.serviceDate,
    super.checkoutDate,
  });

  factory PressModel.fromJson(Map<String, dynamic> json) {
      // 1. Mapeo seguro del estado
      String rawState = json['operation_state']?.toString().toUpperCase() ?? 'AVAILABLE';
      String translatedState = _mapStateToSpanish(rawState);
  
      // 2. Mapeo seguro del tipo
      String rawType = json['type']?.toString() ?? 'Mecanica';
      String translatedType = _mapTypeToSpanish(rawType);
  
      return PressModel(
        id: json['press_id']?.toString() ?? '',
        type: translatedType,
        model: json['model']?.toString() ?? 'N/A',
        volts: json['volts']?.toString() ?? 'N/A',
        serie: json['serie']?.toString() ?? 'N/A',
        size: json['size']?.toString() ?? 'N/A',
        isActive: json['is_active'] == true,
  
        operationState: translatedState,
        // Usamos un string por defecto si viene null para evitar errores de tipo
        currentLocation: json['current_location']?.toString() ?? 'Taller Central',
        responsible: json['responsible']?.toString() ?? 
                     json['solicitants_name']?.toString() ?? 
                     'N/A',
                     
        // Estos deben permitir nulos (String?) tanto aquí como en la entidad Press
        serviceReason: json['service_reason']?.toString(),
        loanComment: json['loan_comment']?.toString(),
        
        serviceDate: json['service_date'] != null 
            ? DateTime.tryParse(json['service_date'].toString()) 
            : null,
        checkoutDate: json['checkout_date'] != null 
            ? DateTime.tryParse(json['checkout_date'].toString()) 
            : null,
      );
    }

  static String _mapStateToSpanish(String state) {
    if (state.contains('IN_SERVICE') || state.contains('MANTENIMIENTO')) {
      return "En Mantenimiento";
    }
    if (state.contains('LOANED') || state.contains('PRESTAMO')) {
      return "En Préstamo";
    }
    if (state.contains('AVAILABLE') || state.contains('DISPONIBLE')) {
      return "Disponible";
    }
    return "En Operación";
  }

  static String _mapTypeToSpanish(String type) {
    final t = type.toLowerCase();
    if (t.contains('hydrau') || t.contains('fija')) return "Hidráulica (Fija)";
    if (t.contains('meca') || t.contains('movil')) return "Mecánica (Móvil)";
    return type;
  }
}