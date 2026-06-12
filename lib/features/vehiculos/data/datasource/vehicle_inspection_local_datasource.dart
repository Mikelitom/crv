import 'dart:convert';

import 'package:crv_reprosisa/features/assets/data/models/vehicle_model.dart';
import 'package:crv_reprosisa/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

abstract class VehicleInspectionLocalDatasource {
  Future<void> saveVehicles(List<VehicleModel> vehicles);

  Future<List<VehicleModel>> getVehicles();
  Future<List<VehicleModel>> getActiveVehicles();

  Future<void> saveVehicleTemplate(Map<String, dynamic> template);
  Future<Map<String, dynamic>> getVehicleTemplate();

  Future<void> saveOfflineReport(Map<String, dynamic> reportData);

  Future<List<PendingVehicleReportsTableData>> getPendingReports();
  Future<void> deletePendingReport(String reportId);

  Future<void> clearVehicles();
}

class VehicleInspectionLocalDataSourceImpl
    implements VehicleInspectionLocalDatasource {
  final AppDatabase db;
  final Box box;

  VehicleInspectionLocalDataSourceImpl(this.db, this.box);

  static const String templateKey = 'vehicle_template';

  @override
  Future<void> saveVehicles(List<VehicleModel> vehicles) async {
    for (final vehicle in vehicles) {
      print('Guardando ${vehicle.vehicleId}');
      await db
          .into(db.vehiclesTable)
          .insertOnConflictUpdate(
            VehiclesTableCompanion(
              vehicleId: Value(vehicle.vehicleId),
              type: Value(vehicle.type),
              typeId: Value(vehicle.typeId),
              brand: Value(vehicle.brand),
              model: Value(vehicle.model),
              unit: Value(vehicle.unit),
              year: Value(vehicle.year),
              plate: Value(vehicle.plate),
              operationState: Value(vehicle.operationState),
              currentLocation: Value(vehicle.currentLocation),
              responsible: Value(vehicle.responsible),
              mileage: Value(vehicle.mileage),
              serviceReason: Value(vehicle.serviceReason),
              phone: Value(vehicle.phone),
              serviceDate: Value(vehicle.serviceDate),
              checkoutDate: Value(vehicle.checkoutDate),
            ),
          );
    }

    final rows = await db.select(db.vehiclesTable).get();

    print('VEHICULOS GUARDADOS: ${rows.length}');
  }

  @override
  Future<List<VehicleModel>> getVehicles() async {
    final rows = await db.select(db.vehiclesTable).get();

    return rows.map((row) {
      return VehicleModel(
        vehicleId: row.vehicleId,
        plate: row.plate,
        brand: row.brand,
        model: row.model,
        year: row.year,
        unit: row.unit,
        type: row.type,
        typeId: row.typeId,
        operationState: row.operationState,
        currentLocation: row.currentLocation,
        responsible: row.responsible,
        mileage: row.mileage ?? 0,
        serviceReason: row.serviceReason,
        phone: row.phone,
        serviceDate: row.serviceDate,
        checkoutDate: row.checkoutDate,
        isActive: row.isActive,
      );
    }).toList();
  }

  @override
  Future<void> saveVehicleTemplate(Map<String, dynamic> template) async {
    await box.put(templateKey, template);
  }

  @override
  Future<Map<String, dynamic>> getVehicleTemplate() async {
    final data = box.get(templateKey);

    if (data == null) {
      return {};
    }

    return Map<String, dynamic>.from(data);
  }

  @override
  Future<void> saveOfflineReport(Map<String, dynamic> reportData) async {
    await db
        .into(db.pendingVehicleReportsTable)
        .insert(
          PendingVehicleReportsTableCompanion.insert(
            id: const Uuid().v4(),
            vehicleId: reportData['vehicle_id'],
            folio: reportData['folio'],
            payload: jsonEncode(reportData),
          ),
        );

    final reports = await db.select(db.pendingVehicleReportsTable).get();

    print("REPORTES PENDIENTES GUARDADOS: ${reports.length}");

    for (final report in reports) {
      print(report.folio);
    }
  }

  @override
  Future<List<PendingVehicleReportsTableData>> getPendingReports() {
    return (db.select(
      db.pendingVehicleReportsTable,
    )..where((t) => t.isSynced.equals(false))).get();
  }

  @override
  Future<void> deletePendingReport(String reportId) async {
    await (db.delete(
      db.pendingVehicleReportsTable,
    )..where((t) => t.id.equals(reportId))).go();
  }

  @override
  Future<void> clearVehicles() async {
    print('cleaning vehicles');
    await db.delete(db.vehiclesTable).go();
    print('vehicles cleaned');
  }

  @override
  Future<List<VehicleModel>> getActiveVehicles() async {
    final rows = await (db.select(
      db.vehiclesTable,
    )..where((t) => t.isActive.equals(true))).get();
  
    return rows.map((row) {
      return VehicleModel(
        vehicleId: row.vehicleId,
        plate: row.plate,
        brand: row.brand,
        model: row.model,
        year: row.year,
        unit: row.unit,
        type: row.type,
        typeId: row.typeId,
        operationState: row.operationState,
        currentLocation: row.currentLocation,
        responsible: row.responsible,
        mileage: row.mileage ?? 0,
        serviceReason: row.serviceReason,
        phone: row.phone,
        serviceDate: row.serviceDate,
        checkoutDate: row.checkoutDate,
        isActive: row.isActive,
      );
    }).toList();
  }
}
