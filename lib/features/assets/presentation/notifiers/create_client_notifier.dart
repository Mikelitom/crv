import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/create_client.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/create_client_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateClientNotifier extends Notifier<CreateClientState> {
  late final CreateClient _createClient;

  @override
  CreateClientState build() {
    _createClient = ref.read(createClientUseCaseProvider);
    return const CreateClientState();
  }

  Future<void> create(CreateClientParams params) async {
    state = state.copyWith(
      status: Status.loading,
      clearError: true,
      clearMessage: true,
    );

    try {
      final result = await _createClient(params);

      result.fold(
        (failure) {
          state = state.copyWith(
            status: Status.error,
            error: failure.message,
          );
        },
        (_) {
          state = state.copyWith(
            status: Status.success,
            message: "Cliente registrado correctamente",
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: Status.error,
        error: "Error inesperado. Intenta de nuevo.",
      );
    }
  }
}
