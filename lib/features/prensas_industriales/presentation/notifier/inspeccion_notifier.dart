import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../provider/inspeccion_providers.dart';
import '../provider/inspeccion_state.dart';

class InspeccionNotifier extends Notifier<InspeccionState> {
  @override
  InspeccionState build() => InspeccionState(inspectionDate: DateTime.now());

  Future<void> onSerieSelected(String serie) async {
    state = state.copyWith(isLoading: true);
    
    final useCase = ref.read(getPressBySerieProvider);
    final result = await useCase(serie);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false);
      },
      (press) {
        // Aquí 'press' es de tipo 'Press' (Entidad)
        state = state.copyWith(selectedPress: press, isLoading: false);
      },
    );
  }

  void onSerieChanged(String serie) {
    if (serie.isEmpty) state = state.copyWith(clearPress: true);
  }

  void updateArea(String area) => state = state.copyWith(area: area);
}