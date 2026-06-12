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
  final Box box;

  ClientLocalDataSourceImpl(this.db, this.box);

  static const String templateKey = 'client_template';

  @override
  Future<void> saveClientTemplate(List<BandaSectionModel> template) async {
    await box.put(templateKey, template);
  }

  @override
  Future<List<BandaSectionModel>> getClientTemplate() async {
    final data = box.get(templateKey);

    if (data == null) {
      return [];
    }

    return data.map((e) => BandaSectionModel.fromJson(e)).toList();
  }
}
