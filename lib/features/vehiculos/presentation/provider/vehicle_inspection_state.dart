import '../../domain/entities/vehicle_entity.dart';
import '../../data/models/component_vehicle_model.dart';

class VehicleInspectionState {
  // =========================
  // Modo de la pantalla
  // =========================
  final String? editingVersionId;

  // =========================
  // Información del reporte
  // =========================
  final Vehicle? selectedVehicle;
  final DateTime inspectionDate;
  final String mileage;
  final bool requiresService;
  final String reportState;
  final String serviceObservations;
  final String generalNotes;

  // =========================
  // Componentes inspeccionados
  // =========================
  final List<ComponentVehicleModel> items;

  // =========================
  // Datos auxiliares
  // =========================
  final List<Vehicle> activeVehicles;
  final List<dynamic> templateSections;
  final List<dynamic> templateOptions;

  // =========================
  // Estado de la UI
  // =========================
  final bool isLoading;
  final bool isScanning;

  const VehicleInspectionState({
    this.editingVersionId,

    this.selectedVehicle,
    required this.inspectionDate,
    this.mileage = '',
    this.requiresService = false,
    this.reportState = 'IN_PROGRESS',
    this.serviceObservations = '',
    this.generalNotes = '',

    this.items = const [],

    this.activeVehicles = const [],
    this.templateSections = const [],
    this.templateOptions = const [],

    this.isLoading = false,
    this.isScanning = false,
  });

  /// =========================
  /// Helpers
  /// =========================

  bool get isEditing => editingVersionId != null;

  bool get isComplete =>
      items.isNotEmpty &&
      items.every((item) => item.selectedOptionId != null);

  /// =========================
  /// copyWith
  /// =========================

  VehicleInspectionState copyWith({
    String? editingVersionId,
    bool clearEditingVersion = false,

    Vehicle? selectedVehicle,
    bool clearVehicle = false,

    DateTime? inspectionDate,
    String? mileage,
    bool? requiresService,
    String? reportState,
    String? serviceObservations,
    String? generalNotes,

    List<ComponentVehicleModel>? items,

    List<Vehicle>? activeVehicles,
    List<dynamic>? templateSections,
    List<dynamic>? templateOptions,

    bool? isLoading,
    bool? isScanning,
  }) {
    return VehicleInspectionState(
      editingVersionId: clearEditingVersion
          ? null
          : (editingVersionId ?? this.editingVersionId),

      selectedVehicle: clearVehicle
          ? null
          : (selectedVehicle ?? this.selectedVehicle),

      inspectionDate: inspectionDate ?? this.inspectionDate,
      mileage: mileage ?? this.mileage,
      requiresService: requiresService ?? this.requiresService,
      reportState: reportState ?? this.reportState,
      serviceObservations:
          serviceObservations ?? this.serviceObservations,
      generalNotes: generalNotes ?? this.generalNotes,

      items: items ?? this.items,

      activeVehicles: activeVehicles ?? this.activeVehicles,
      templateSections: templateSections ?? this.templateSections,
      templateOptions: templateOptions ?? this.templateOptions,

      isLoading: isLoading ?? this.isLoading,
      isScanning: isScanning ?? this.isScanning,
    );
  }
}