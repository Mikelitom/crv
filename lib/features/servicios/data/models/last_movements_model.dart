import 'package:crv_reprosisa/features/servicios/domain/entities/asset_last_movement.dart';

class DashboardLastMovements {
  final List<AssetLastMovement> vehicles;
  final List<AssetLastMovement> presses;

  const DashboardLastMovements({
    required this.vehicles,
    required this.presses,
  });

  factory DashboardLastMovements.fromJson(Map<String, dynamic> json) {
    return DashboardLastMovements(
      vehicles: (json["vehicles"] as List)
          .map((e) => AssetLastMovement.fromJson(e))
          .toList(),
      presses: (json["presses"] as List)
          .map((e) => AssetLastMovement.fromJson(e))
          .toList(),
    );
  }
}