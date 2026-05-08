import '../../data/models/vehicle_catalog_model.dart';
import '../../data/models/press_loan_model.dart';

enum CatalogoStatus { initial, loading, success, error }

class CatalogoState {
  final List<VehicleCatalogModel> vehicles;
  final List<PressLoanModel> presses;
  final CatalogoStatus status;
  final String? errorMessage;
  final String? searchQuery;

  CatalogoState({
    this.vehicles = const [],
    this.presses = const [],
    this.status = CatalogoStatus.initial,
    this.errorMessage,
    this.searchQuery,
  });

  CatalogoState copyWith({
    List<VehicleCatalogModel>? vehicles,
    List<PressLoanModel>? presses,
    CatalogoStatus? status,
    String? errorMessage,
    String? searchQuery,
  }) {
    return CatalogoState(
      vehicles: vehicles ?? this.vehicles,
      presses: presses ?? this.presses,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<VehicleCatalogModel> get filteredVehicles {
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final query = searchQuery!.toLowerCase();
      return vehicles
          .where(
            (v) =>
                v.plate.toLowerCase().contains(query) ||
                (v.responsible?.toLowerCase().contains(query) ?? false),
          )
          .toList();
    }
    return vehicles;
  }

  List<PressLoanModel> get filteredPresses {
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final query = searchQuery!.toLowerCase();
      return presses
          .where(
            (p) =>
                p.pressId.toLowerCase().contains(query) ||
                (p.solicitantsName?.toLowerCase().contains(query) ?? false),
          )
          .toList();
    }
    return presses;
  }
}
