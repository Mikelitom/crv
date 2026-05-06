import '../../domain/entities/vehicle_entity.dart';
import '../../data/models/component_vehicle_model.dart';

class VehicleInspectionState {
  final Vehicle? selectedVehicle;
  final List<Vehicle> activeVehicles;
  final List<dynamic> templateSections;
  final List<dynamic> templateOptions;
  final List<ComponentVehicleModel> items; 
  final DateTime inspectionDate;
  final String mileage;
  final bool requiresService;
  final bool isLoading;
  final bool isScanning;
  final String serviceObservations;

  VehicleInspectionState({
    this.selectedVehicle,
    this.activeVehicles = const [],
    this.templateSections = const [],
    this.templateOptions = const [],
    this.items = const [],
    required this.inspectionDate,
    this.mileage = '',
    this.requiresService = false,
    this.isLoading = false,
    this.isScanning = false,
    this.serviceObservations = '',
  });

  VehicleInspectionState copyWith({
    Vehicle? selectedVehicle,
    bool clearVehicle = false,
    List<Vehicle>? activeVehicles,
    List<dynamic>? templateSections,
    List<dynamic>? templateOptions,
    List<ComponentVehicleModel>? items,
    DateTime? inspectionDate,
    String? mileage,
    bool? requiresService,
    bool? isLoading,
    bool? isScanning,
    String? serviceObservations,
  }) {
    return VehicleInspectionState(
      selectedVehicle: clearVehicle ? null : (selectedVehicle ?? this.selectedVehicle),
      activeVehicles: activeVehicles ?? this.activeVehicles,
      templateSections: templateSections ?? this.templateSections,
      templateOptions: templateOptions ?? this.templateOptions,
      items: items ?? this.items,
      inspectionDate: inspectionDate ?? this.inspectionDate,
      mileage: mileage ?? this.mileage,
      requiresService: requiresService ?? this.requiresService,
      isLoading: isLoading ?? this.isLoading,
      isScanning: isScanning ?? this.isScanning,
      serviceObservations: serviceObservations ?? this.serviceObservations,
    );
  }
}