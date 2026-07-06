// lib/features/servicios/presentation/notifiers/press_incidence_notifier.dart
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/press/press_incidence_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/assets/presentation/states/status.dart';

class PressIncidenceNotifier extends Notifier<PressIncidenceState> {
  @override
  PressIncidenceState build() => const PressIncidenceState();

  Future<void> loadIncidences(String pressId) async {
    state = state.copyWith(status: Status.loading);
    // Necesitaremos este provider más abajo
    final useCase = ref.read(getPressIncidenceSummaryUseCaseProvider);
    final result = await useCase.call(pressId);
    
    state = result.fold(
      (l) => state.copyWith(status: Status.error, error: l.message),
      (r) => state.copyWith(status: Status.success, incidences: r),
    );
  }
}