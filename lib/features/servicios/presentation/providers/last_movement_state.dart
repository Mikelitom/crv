import 'package:crv_reprosisa/features/servicios/domain/entities/asset_last_movement.dart';

class DashboardState {
  final bool isLoading;
  final String searchQuery;

  final List<AssetLastMovement> vehicleMovements;
  final List<AssetLastMovement> pressMovements;

  const DashboardState({
    this.isLoading = false,
    this.searchQuery = '',
    this.vehicleMovements = const [],
    this.pressMovements = const [],
  });

  DashboardState copyWith({
    bool? isLoading,
    String? searchQuery,
    List<AssetLastMovement>? vehicleMovements,
    List<AssetLastMovement>? pressMovements,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      vehicleMovements: vehicleMovements ?? this.vehicleMovements,
      pressMovements: pressMovements ?? this.pressMovements,
    );
  }
}