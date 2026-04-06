import 'package:crv_reprosisa/features/assets/domain/usecases/create_client.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/get_all_clients.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/update_client.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createClientUseCaseProvider = Provider<CreateClient>((ref) {
  final repository = ref.read(clientRepositoryProvider);
  return CreateClient(repository);
});

final updateClientUseCaseProvider = Provider<UpdateClient>((ref) {
  final repository = ref.read(clientRepositoryProvider);
  return UpdateClient(repository);
});

final getAllClientsUseCaseProvider = Provider<GetAllClients>((ref) {
  final repository = ref.read(clientRepositoryProvider);
  return GetAllClients(repository);
});
