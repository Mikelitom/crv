import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/core/database/database_provider.dart';
import 'package:crv_reprosisa/features/assets/data/datasource/client_remote_datasource.dart';
import 'package:crv_reprosisa/features/assets/data/datasource/client_remote_datasource_impl.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/data/datasource/client_local_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final clientRemoteDatasourceProvider = Provider<ClientRemoteDatasource>((ref) {
  final dio = ref.read(dioProvider);

  return ClientRemoteDatasourceImpl(dio);
});

final clientLocalDataSourceProvider = Provider<ClientLocalDataSource>((ref) {
  final db = ref.read(appDatabaseProvider);
  final box = Hive.box('conveyor_cache');
  return ClientLocalDataSourceImpl(db, box);
});
