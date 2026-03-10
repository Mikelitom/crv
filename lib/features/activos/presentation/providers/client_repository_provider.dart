import 'package:crv_reprosisa/features/activos/data/repositories/client_repository_impl.dart';
import 'package:crv_reprosisa/features/activos/domain/repositories/client_repository.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/client_remote_datasource_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clientRepositoryProvider = Provider<ClientRepository>((ref) {
  final datasource = ref.read(clientRemoteDatasourceProvider);
  return ClientRepositoryImpl(datasource);
});
