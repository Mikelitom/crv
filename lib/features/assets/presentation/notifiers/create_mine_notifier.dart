import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/create_mine.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/client_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class CreateMineNotifier extends Notifier<ClientState> {
  late final CreateMine _createMine;

  @override
  ClientState build() {
    _createMine = ref.read(createMineUseCaseProvider);
    return const ClientState(status: Status.initial);
  }

  Future<void> create(String clientId, CreateMineParams params) async {
    // Aquí usamos los parámetros exactos de tu método copyWith definido en ClientState
    state = state.copyWith(
      status: Status.loading,
      clearError: true,
      clearMessage: true,
    );
    
    final result = await _createMine(clientId, params);
    
    result.fold(
      (failure) {
        state = state.copyWith(
          status: Status.error, 
          error: failure.message
        );
      },
      (_) {
        state = state.copyWith(
          status: Status.success,
          message: "Mina registrada exitosamente"
        );
      },
    );
  }
}