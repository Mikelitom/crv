import 'package:crv_reprosisa/features/assets/data/datasource/client_remote_datasource.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/data/datasource/client_local_datasource.dart';

class ClientSyncService {
  final ClientRemoteDatasource remote;
  final ClientLocalDataSource local;

  ClientSyncService({
    required this.remote,
    required this.local
  });
}
