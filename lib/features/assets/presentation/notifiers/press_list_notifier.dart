import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/press_usecase_provider.dart';
import '../states/press_list_state.dart';
import '../states/status.dart';

class PressListNotifier extends Notifier<PressListState> {

  // Quitamos el 'late' y lo manejamos directamente en el build si prefieres,
  // pero el cambio clave es el watch.

  @override
  PressListState build() {
    // IMPORTANTE: Usar watch para que el Notifier esté vinculado al ciclo de vida del caso de uso
    // Si el caso de uso depende de un repositorio que depende de una API,
    // watch asegura que todo esté listo antes de ejecutar.
    return const PressListState();
  }

  Future<void> loadPress() async {
    // Evita llamadas infinitas si ya está cargando
    if (state.status == Status.loading) return;

    state = state.copyWith(status: Status.loading);

    // Obtenemos el caso de uso justo al momento de la llamada
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
        // Log de debug para descartar que la API regrese []
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
