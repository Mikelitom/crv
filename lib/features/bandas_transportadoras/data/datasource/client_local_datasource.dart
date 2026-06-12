import 'dart:convert';

import 'package:crv_reprosisa/features/assets/data/models/clients_model.dart';
import 'package:crv_reprosisa/core/database/app_database.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/data/models/banda_models.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/domain/entities/banda_template.dart';
import 'package:hive/hive.dart';
import 'package:drift/drift.dart';

abstract class ClientLocalDataSource {
  // Future<void> saveClients(List<ClientsModel> clients);
  // Future<List<ClientsModel>> getClients();

  Future<void> saveClientTemplate(List<BandaSectionModel> template);
  Future<List<BandaSectionModel>> getClientTemplate();

  // Future<void> saveOfflineReport(Map<String, dynamic> report);
}

class ClientLocalDataSourceImpl implements ClientLocalDataSource {
  final AppDatabase db;
  final Box<dynamic> box;

  ClientLocalDataSourceImpl(this.db, this.box);

  static const String templateKey = 'client_template';

  @override
  Future<void> saveClientTemplate(List<BandaSectionModel> template) async {
    final jsonString = jsonEncode(
      template.map((e) => e.toJson()).toList(),
    );
  
    await box.put(templateKey, jsonString);
  }

  @override
  Future<List<BandaSectionModel>> getClientTemplate() async {
    final raw = box.get(templateKey);
  
    if (raw == null) return [];
  
    final List decoded = jsonDecode(raw);
  
    return decoded
        .map((e) => BandaSectionModel.fromJson(
              Map<String, dynamic>.from(e),
            ))
        .toList();
  }
}
