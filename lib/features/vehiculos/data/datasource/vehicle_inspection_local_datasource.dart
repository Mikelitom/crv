import 'package:crv_reprosisa/features/vehiculos/data/models/inspection_vehicle_model.dart';
import 'package:crv_reprosisa/core/database/app_database.dart';
import 'package:drift/drift.dart';

abstract class VehicleInspectionLocalDatasource {
  Future<void> saveVehicles(List<VehicleModel> vehicles);

  Future<List<VehicleModel>> getVehicles();
}

class VehicleInspectionLocalDataSourceImpl
    implements VehicleInspectionLocalDatasource {
  final AppDatabase db;

  VehicleInspectionLocalDataSourceImpl(this.db);

  @override
  Future<void> saveVehicles(List<VehicleModel> vehicles) async {
    for (final vehicle in vehicles) {
      await db
          .into(db.vehiclesTable)
          .insertOnConflictUpdate(
            VehiclesTableCompanion(
              id: Value(vehicle.id),
              typeId: Value(vehicle.typeId),
              brand: Value(vehicle.brand),
              model: Value(vehicle.model),
              unit: Value(vehicle.unit),
              year: Value(vehicle.year),
              plate: Value(vehicle.plate),
              isActive: const Value(true),
            ),
          );
    }
  }

  @override
  Future<List<VehicleModel>> getVehicles() async {
    final rows = await db.select(db.vehiclesTable).get();

    return rows.map((row) {
      return VehicleModel(
        id: row.id,
        typeId: row.typeId,
        brand: row.brand,
        model: row.model,
        unit: row.unit,
        year: row.year,
        plate: row.plate,
      );
    }).toList();
  }
}
