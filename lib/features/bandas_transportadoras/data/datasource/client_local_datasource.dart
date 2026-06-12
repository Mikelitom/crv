import 'dart:convert';

import 'package:crv_reprosisa/features/assets/data/models/clients_model.dart';
import 'package:crv_reprosisa/core/database/app_database.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/data/models/banda_models.dart';
import 'package:hive/hive.dart';
import 'package:drift/drift.dart';

abstract class ClientLocalDataSource {
  Future<void> saveClients(List<ClientsModel> clients);
  Future<List<ClientsModel>> getClients();

  Future<void> saveClientTemplate(List<BandaSectionModel> template);
  Future<List<BandaSectionModel>> getClientTemplate();

  Future<List<ClientsModel>> getActiveClients();
  Future<List<MineModel>> getActiveMines();

  // Future<void> saveOfflineReport(Map<String, dynamic> report);
}

class ClientLocalDataSourceImpl implements ClientLocalDataSource {
  final AppDatabase db;
  final Box<dynamic> box;

  ClientLocalDataSourceImpl(this.db, this.box);

  static const String templateKey = 'client_template';

  @override
  Future<void> saveClients(List<ClientsModel> clients) async {
    await db.transaction(() async {
      for (final client in clients) {
        await db
            .into(db.clientsTable)
            .insertOnConflictUpdate(
              ClientsTableCompanion(
                id: Value(client.id),
                name: Value(client.name),
                company: Value(client.company),
                phone: Value(client.phone),
                email: Value(client.email),
                isActive: Value(client.isActive),
                createdAt: Value(client.createdAt),
              ),
            );

        final mines = client.mines ?? <MineModel>[];

        for (final mine in mines) {
          await db
              .into(db.minesTable)
              .insertOnConflictUpdate(
                MinesTableCompanion(
                  id: Value(mine.id),
                  clientId: Value(client.id), // relación manual correcta
                  name: Value(mine.name),
                  address: Value(mine.address),
                  phone: Value(mine.phone),
                  email: Value(mine.email),
                  isActive: Value(mine.isActive),
                  createdAt: Value(mine.createdAt),
                ),
              );
        }
      }
    });
  }

  @override
  Future<List<ClientsModel>> getActiveClients() async {
    final rows =
        await (db.select(
          db.clientsTable,
        )..where((c) => c.isActive.equals(true))).get();
  
    final clients = <ClientsModel>[];
  
    for (final c in rows) {
      final mines =
          await (db.select(
            db.minesTable,
          )..where(
            (m) => m.clientId.equals(c.id) & m.isActive.equals(true),
          )).get();
  
      clients.add(
        ClientsModel(
          id: c.id,
          name: c.name,
          company: c.company,
          phone: c.phone,
          email: c.email,
          createdAt: c.createdAt,
          isActive: c.isActive,
          mines: mines
              .map(
                (m) => MineModel(
                  id: m.id,
                  clientId: m.clientId,
                  name: m.name,
                  address: m.address,
                  phone: m.phone,
                  email: m.email,
                  isActive: m.isActive,
                  createdAt: m.createdAt,
                ),
              )
              .toList(),
        ),
      );
    }
  
    return clients;
  }
  
  @override
  Future<List<MineModel>> getActiveMines() async {
    final mines =
        await (db.select(
          db.minesTable,
        )..where((m) => m.isActive.equals(true))).get();
  
    return mines
        .map(
          (m) => MineModel(
            id: m.id,
            clientId: m.clientId,
            name: m.name,
            address: m.address,
            phone: m.phone,
            email: m.email,
            isActive: m.isActive,
            createdAt: m.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<List<ClientsModel>> getClients() async {
    final query = await (db.select(db.clientsTable).join([
      leftOuterJoin(
        db.minesTable,
        db.minesTable.clientId.equalsExp(db.clientsTable.id),
      ),
    ])).get();

    final Map<String, ClientsModel> clientsMap = {};

    for (final row in query) {
      final client = row.readTable(db.clientsTable);
      final mine = row.readTableOrNull(db.minesTable);

      final clientId = client.id;

      if (!clientsMap.containsKey(clientId)) {
        clientsMap[clientId] = ClientsModel(
          id: client.id,
          name: client.name,
          company: client.company,
          phone: client.phone,
          email: client.email,
          createdAt: client.createdAt,
          isActive: client.isActive,
          mines: [],
        );
      }

      if (mine != null) {
        clientsMap[clientId]!.mines!.add(
          MineModel(
            id: mine.id,
            clientId: mine.clientId,
            name: mine.name,
            address: mine.address,
            phone: mine.phone,
            email: mine.email,
            isActive: mine.isActive,
            createdAt: mine.createdAt,
          ),
        );
      }
    }

    return clientsMap.values.toList();
  }

  @override
  Future<void> saveClientTemplate(List<BandaSectionModel> template) async {
    final jsonString = jsonEncode(template.map((e) => e.toJson()).toList());

    await box.put(templateKey, jsonString);
  }

  @override
  Future<List<BandaSectionModel>> getClientTemplate() async {
    final raw = box.get(templateKey);

    if (raw == null) return [];

    final List decoded = jsonDecode(raw);

    return decoded
        .map((e) => BandaSectionModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
