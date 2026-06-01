import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Imports de Casos de Uso ---
import 'package:crv_reprosisa/features/assets/domain/usecases/create_client.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/get_all_clients.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/update_client.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/activate_client.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/delete_client.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/activate_mine.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/delete_mine.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/create_mine.dart'; // <--- ASEGÚRATE DE TENER ESTE IMPORT

// --- Import de Repositorio ---
import 'package:crv_reprosisa/features/assets/presentation/providers/client_repository_provider.dart';

// --- Providers de Casos de Uso ---
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

final activateClientUseCaseProvider = Provider<ActivateClient>((ref) {
  return ActivateClient(ref.read(clientRepositoryProvider));
});

final deleteClientUseCaseProvider = Provider<DeleteClient>((ref) {
  return DeleteClient(ref.read(clientRepositoryProvider));
});

final activateMineUseCaseProvider = Provider<ActivateMine>((ref) {
  return ActivateMine(ref.read(clientRepositoryProvider));
});

final deleteMineUseCaseProvider = Provider<DeleteMine>((ref) {
  return DeleteMine(ref.read(clientRepositoryProvider));
});

// --- ESTE ES EL PROVIDER QUE FALTABA ---
final createMineUseCaseProvider = Provider<CreateMine>((ref) {
  return CreateMine(ref.read(clientRepositoryProvider));
});