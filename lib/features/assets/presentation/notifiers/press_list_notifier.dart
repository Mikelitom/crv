import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/press_usecase_provider.dart';
import '../states/press_list_state.dart';
import '../states/status.dart';

class PressListNotifier extends Notifier<PressListState> {

  @override
  PressListState build() {
  
    return const PressListState();
  }

  Future<void> loadPress() async {
    if (state.status == Status.loading) return;

    state = state.copyWith(status: Status.loading);
    final getAllPress = ref.read(getAllPressUseCaseProvider);
    final result = await getAllPress();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: Status.error,
          error: failure.message
        );
      },
      (pressList) {
        print("DEBUG: Prensas cargadas: ${pressList.length}");

        state = state.copyWith(
          status: Status.success,
          press: pressList,
          error: null
        );
      },
    );
  }
}
