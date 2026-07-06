import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/service_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/vehicle/incidence_state_g.dart';
import '../../../../features/assets/presentation/states/status.dart';

class IncidenceNotifierG extends Notifier<IncidenceStateG> {
  @override
  IncidenceStateG build() => const IncidenceStateG();

  Future<void> loadIncidences(String vehicleId) async {
    state = state.copyWith(status: Status.loading);
    
    // Asumiremos que el provider se llama getIncidenceSummaryUseCaseProvider
    final useCase = ref.read(getIncidenceSummaryUseCaseProvider);
    final result = await useCase.call(vehicleId);

    state = result.fold(
      (failure) => state.copyWith(status: Status.error, error: failure.message),
      (data) => state.copyWith(status: Status.success, incidences: data),
    );
  }
}