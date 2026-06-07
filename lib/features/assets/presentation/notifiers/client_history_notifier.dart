import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import '../states/client_history_state.dart';

class ClientHistoryNotifier extends Notifier<ClientHistoryState> {
  
  @override
  ClientHistoryState build() {
    return const ClientHistoryState(status: Status.initial);
  }

  Future<void> loadHistory(String clientId) async {
    state = state.copyWith(status: Status.loading);
    
    final useCase = ref.read(getClientHistoryUseCaseProvider);
    final result = await useCase(clientId);
    
    result.fold(
      (failure) => state = state.copyWith(
        status: Status.error, 
        error: failure.toString() // O failure.message dependiendo de tu clase Failure
      ),
      (data) => state = state.copyWith(
        status: Status.success, 
        history: data
      ),
    );
  }
}