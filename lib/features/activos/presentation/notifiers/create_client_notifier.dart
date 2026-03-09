import 'package:crv_reprosisa/features/activos/domain/params/create_clients_params.dart';
import 'package:crv_reprosisa/features/activos/domain/usecases/create_client.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/client_usecase_provider.dart';
import 'package:crv_reprosisa/features/activos/presentation/states/create_client_state.dart';
import 'package:crv_reprosisa/features/activos/presentation/states/status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateClientNotifier extends Notifier<CreateClientState> {
  late final CreateClient _createClient;

  @override
  CreateClientState build() {
    _createClient = ref.read(createClientUseCaseProvider);
    return const CreateClientState();
  }

  Future<void> create(CreateClientParams params) async {
    state = state.copyWith(status: Status.loading);

    final result = await _createClient(params);

    result.fold(
      (failure) {
        state = state.copyWith(status: Status.error, error: failure.message);
      },
      (_) {
        state = state.copyWith(status: Status.success);
      },
    );
  }
}
