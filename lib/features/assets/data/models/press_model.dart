import '../../domain/entities/press.dart';

class PressModel extends Press {
  PressModel({
    required super.id,
    required super.type,
    required super.model,
    required super.volts,
    required super.serie,
    required super.size,
    required super.createdAt,
    required super.updatedAt,
    required super.isActive,
    super.operationState,
    super.currentLocation,
    super.responsible,
    super.phone,
    super.loanComment,
    super.serviceReason,
    super.serviceDate,
    super.checkoutDate,
  });

  factory PressModel.fromJson(Map<String, dynamic> json) {
    // 1. Mapeo del estado a español
    String rawState =
        json['operation_state']?.toString().toUpperCase() ?? 'AVAILABLE';
    String translatedState = _mapStateToSpanish(rawState);

    // 2. Mapeo del tipo a español
    String rawType = json['type']?.toString() ?? 'Mecanica';
    String translatedType = _mapTypeToSpanish(rawType);

    return PressModel(
      id: json['press_id']?.toString() ?? '',
      type: translatedType, // Usamos el tipo traducido
      model: json['model']?.toString() ?? 'N/A',
      volts: json['volts']?.toString() ?? 'N/A',
      serie: json['serie']?.toString() ?? 'N/A',
      size: json['size']?.toString() ?? 'N/A',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      isActive: json['is_active'] ?? true,

      operationState: translatedState, // Guardamos el estado traducido
      currentLocation: json['current_location']?.toString() ?? 'Sin ubicación',
      responsible:
          json['responsible']?.toString() ??
          json['solicitants_name']?.toString() ??
          'N/A',
      phone: json['phone']?.toString() ?? 'N/A',
      serviceReason: json['service_reason']?.toString(),
      loanComment: json['loan_comment']?.toString(),
      serviceDate: json['service_date'] != null
          ? DateTime.parse(json['service_date'])
          : null,
      checkoutDate: json['checkout_date'] != null
          ? DateTime.parse(json['checkout_date'])
          : null,
    );
  }

  // Lógica de traducción de Estados
  static String _mapStateToSpanish(String state) {
    if (state.contains('IN_SERVICE') || state.contains('MANTENIMIENTO'))
      return "En Mantenimiento";
    if (state.contains('LOANED') ||
        state.contains('PRESTAMO') ||
        state.contains('LOANED'))
      return "En Préstamo";
    if (state.contains('AVAILABLE') || state.contains('DISPONIBLE'))
      return "Disponible";
    return "En Operación";
  }

  // Lógica de traducción de Tipos
  static String _mapTypeToSpanish(String type) {
    final t = type.toLowerCase();
    if (t.contains('hydrau') || t.contains('fija')) return "Hidráulica (Fija)";
    if (t.contains('meca') || t.contains('movil')) return "Mecánica (Móvil)";
    return type;
  }
}
