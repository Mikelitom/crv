import 'dart:convert';

import 'package:crv_reprosisa/core/database/app_database.dart';
import 'package:crv_reprosisa/features/prensas_industriales/data/models/loan_area_model.dart';
import 'package:crv_reprosisa/features/assets/data/models/press_model.dart';
import 'package:drift/drift.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';

abstract class PressInspectionLocalDataSource {
  Future<void> savePresses(List<PressModel> presses);
  Future<List<PressModel>> getPresses();

  Future<void> saveLoanAreas(List<LoanAreaModel> loanAreas);
  Future<List<LoanAreaModel>> getLoanAreas();

  Future<void> savePressTemplate(Map<String, dynamic> template);
  Future<Map<String, dynamic>> getPressTemplate();

  Future<void> saveOfflineReport(Map<String, dynamic> reportData);
  Future<List<PendingPressReportsTableData>> getPendingReports();
  Future<void> deletePendingReport(String reportId);

  Future<void> clearPresses();
  Future<void> clearLoanAreas();

  Future<PressModel?> getPressBySerie(String serie);

  Future<List<String>> getAllSeries();
}

class PressInspectionLocalDataSourceImpl
    implements PressInspectionLocalDataSource {
  final AppDatabase db;
  final Box box;

  PressInspectionLocalDataSourceImpl(this.db, this.box);

  static const String templateKey = 'press_template';

  @override
  Future<void> savePresses(List<PressModel> presses) async {
    for (final press in presses) {
      await db
          .into(db.pressesTable)
          .insertOnConflictUpdate(
            PressesTableCompanion(
              id: Value(press.id),
              serie: Value(press.serie),

              size: Value(press.size == 'N/A' ? null : press.size),

              type: Value(press.type),

              model: Value(press.model == 'N/A' ? null : press.model),

              volts: Value(press.volts == 'N/A' ? null : press.volts),

              isActive: Value(press.isActive),

              operationState: Value(press.operationState ?? 'AVAILABLE'),

              currentLocation: Value(
                press.currentLocation ?? 'TALLER CENTRAL REPROSISA',
              ),

              solicitantsName: Value(
                press.responsible == 'N/A' ? null : press.responsible,
              ),

              loanComment: Value(press.loanComment),

              serviceReason: Value(press.serviceReason),

              serviceDate: Value(press.serviceDate),

              checkoutDate: Value(press.checkoutDate),
            ),
          );
    }
  }

  @override
  Future<List<PressModel>> getPresses() async {
    final rows = await db.select(db.pressesTable).get();

    return rows.map((row) {
      return PressModel(
        id: row.id,
        serie: row.serie,
        size: row.size ?? 'N/A',
        type: row.type,
        model: row.model ?? 'N/A',
        volts: row.volts ?? 'N/A',

        isActive: row.isActive,

        operationState: row.operationState,
        currentLocation: row.currentLocation,

        responsible: row.solicitantsName ?? 'N/A',

        loanComment: row.loanComment,

        serviceReason: row.serviceReason,

        serviceDate: row.serviceDate,

        checkoutDate: row.checkoutDate,
      );
    }).toList();
  }

  @override
  Future<void> saveLoanAreas(List<LoanAreaModel> loanAreas) async {
    for (final area in loanAreas) {
      await db
          .into(db.loanAreasTable)
          .insertOnConflictUpdate(
            LoanAreasTableCompanion(
              id: Value(area.id),
              name: Value(area.name),
              address: Value(area.address),
              contact: Value(area.contact),
            ),
          );
    }
  }

  @override
  Future<List<LoanAreaModel>> getLoanAreas() async {
    final rows = await db.select(db.loanAreasTable).get();

    return rows.map((row) {
      return LoanAreaModel(
        id: row.id,
        name: row.name,
        address: row.address,
        contact: row.contact,
      );
    }).toList();
  }

  @override
  Future<void> savePressTemplate(Map<String, dynamic> template) async {
    await box.put(templateKey, template);
  }

  @override
  Future<Map<String, dynamic>> getPressTemplate() async {
    final data = box.get(templateKey);

    if (data == null) {
      return {};
    }

    return Map<String, dynamic>.from(data);
  }

  @override
  Future<void> clearPresses() async {
    await db.delete(db.pressesTable).go();
  }

  @override
  Future<void> clearLoanAreas() async {
    await db.delete(db.loanAreasTable).go();
  }

  @override
  Future<List<String>> getAllSeries() async {
    final rows = await db.select(db.pressesTable).get();

    return rows.map((e) => e.serie).toList();
  }

  @override
  Future<PressModel?> getPressBySerie(String serie) async {
    final row = await (db.select(
      db.pressesTable,
    )..where((t) => t.serie.equals(serie))).getSingleOrNull();

    if (row == null) {
      return null;
    }

    return PressModel(
      id: row.id,
      serie: row.serie,
      size: row.size ?? 'N/A',
      type: row.type,
      model: row.model ?? 'N/A',
      volts: row.volts ?? 'N/A',
      isActive: row.isActive,

      operationState: row.operationState,
      currentLocation: row.currentLocation,

      responsible: row.solicitantsName ?? 'N/A',

      loanComment: row.loanComment,
      serviceReason: row.serviceReason,

      serviceDate: row.serviceDate,
      checkoutDate: row.checkoutDate,
    );
  }

  @override
  Future<void> saveOfflineReport(Map<String, dynamic> reportData) async {
    await db
        .into(db.pendingPressReportsTable)
        .insert(
          PendingPressReportsTableCompanion.insert(
            id: const Uuid().v4(),
            pressId: reportData['press_id'],
            folio: reportData['folio'],
            payload: jsonEncode(reportData),
          ),
        );

    final reports = await db.select(db.pendingPressReportsTable).get();

    print("REPORTES PENDIENTES GUARDADOS: ${reports.length}");

    for (final report in reports) {
      print(report.folio);
    }
  }

  @override
  Future<List<PendingPressReportsTableData>> getPendingReports() {
    return (db.select(
      db.pendingPressReportsTable,
    )..where((t) => t.isSynced.equals(false))).get();
  }

  @override
  Future<void> deletePendingReport(String reportId) async {
    await (db.delete(
      db.pendingPressReportsTable,
    )..where((t) => t.id.equals(reportId))).go();
  }
}
