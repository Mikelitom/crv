import 'package:crv_reprosisa/features/assets/domain/usecases/get_all_clients.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/clients_list_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientListNotifier extends Notifier<ClientsListState> {
  late final GetAllClients _getAllClients;

  @override
  ClientsListState build() {
    _getAllClients = ref.read(getAllClientsUseCaseProvider);
    return const ClientsListState();
  }

  Future<void> loadClients() async {
    state = state.copyWith(status: Status.loading);

    final result = await _getAllClients();

    result.fold(
      (failure) {
        state = state.copyWith(status: Status.error, error: failure.message);
      },
      (clients) {
        state = state.copyWith(status: Status.success, clients: clients);
      },
    );
  }
}
