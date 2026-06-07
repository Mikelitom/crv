import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/create_client.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/get_all_clients.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/update_client.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/activate_client.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/delete_client.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/activate_mine.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/delete_mine.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/create_mine.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/get_client_history_usecase.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/get_conveyor_report_detail_usecase.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_repository_provider.dart';

// --- Providers de Casos de Uso ---

final createClientUseCaseProvider = Provider<CreateClient>((ref) {
  return CreateClient(ref.read(clientRepositoryProvider));
});

final updateClientUseCaseProvider = Provider<UpdateClient>((ref) {
  return UpdateClient(ref.read(clientRepositoryProvider));
});

final getAllClientsUseCaseProvider = Provider<GetAllClients>((ref) {
  return GetAllClients(ref.read(clientRepositoryProvider));
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

final createMineUseCaseProvider = Provider<CreateMine>((ref) {
  return CreateMine(ref.read(clientRepositoryProvider));
});

// En tu archivo de providers:
final getClientHistoryUseCaseProvider = Provider((ref) {
  return GetClientHistory(ref.read(clientRepositoryProvider)); // Cambiado aquí también
});final getConveyorReportDetailUseCaseProvider = Provider<GetConveyorReportDetailUseCase>((ref) {
  return GetConveyorReportDetailUseCase(ref.read(clientRepositoryProvider));
});