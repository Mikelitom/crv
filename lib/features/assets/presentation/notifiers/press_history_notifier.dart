import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_usecase_provider.dart'; // Asegúrate de importar tu provider de usecases
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/press_history_state.dart';

class PressHistoryNotifier extends Notifier<PressHistoryState> {
  
  @override
  PressHistoryState build() {
    return const PressHistoryState(status: Status.initial);
  }

  Future<void> loadHistory(String pressId) async {
    state = state.copyWith(status: Status.loading);
    
    final result = await ref.read(getPressHistoryUseCaseProvider)(pressId);

    result.fold(
      (failure) => state = state.copyWith(status: Status.error, error: failure.message),
      (data) => state = state.copyWith(status: Status.success, history: data),
    );
  }
}