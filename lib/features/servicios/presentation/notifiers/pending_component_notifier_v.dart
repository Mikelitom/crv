import 'package:crv_reprosisa/features/servicios/data/models/vehiculos/pending_component_entity_v.dart' show PendingComponentModelV;
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/pending_componenet_state_v.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/pending_component_provider_v.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class PendingComponentNotifier extends Notifier<PendingComponentState> {
  @override
  PendingComponentState build() => const PendingComponentState();

  Future<void> loadPendingComponents(String vehicleId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await ref.read(getPendingComponentsUseCaseProvider).call(vehicleId);
    
    state = result.fold(
      (failure) => state.copyWith(isLoading: false, error: failure.toString()),
      (data) {
        final Map<String, int> conteo = {};
        // Guardamos el objeto original para recuperar datos si es necesario
        final Map<String, PendingComponentModelV> unicos = {};

        for (var item in data) {
          final option = item.selectedOption.toLowerCase();
          
          // Solo si es un estado que requiere acción (Mala, Reposición, Reparación)
          if (option.contains('mala') || option.contains('repos') || option.contains('repa')) {
            conteo[item.componentName] = (conteo[item.componentName] ?? 0) + 1;
            // Guardamos la referencia para el modelo final
            unicos[item.componentName] = item as PendingComponentModelV;
          }
        }

        // 2. CONSTRUIR LISTA ÚNICA
        final listaProcesada = unicos.entries.map((entry) {
          final name = entry.key;
          final item = entry.value;
          int count = conteo[name] ?? 0;
          
          String nuevoStatus = 'PENDIENTE';
          if (count > 3) nuevoStatus = 'CRÍTICO';
          else if (count > 1) nuevoStatus = 'ATENCIÓN'; // >1 y <=3

          return PendingComponentModelV(
            id: item.id,
            vehicleId: item.vehicleId,
            serviceId: item.serviceId,
            componentId: item.componentId,
            componentName: name,
            reportAnswerId: item.reportAnswerId,
            selectedOption: item.selectedOption,
            description: item.description,
            observation: "Historial: $count incidencias detectadas",
            status: nuevoStatus,
            completedAt: item.completedAt,
            createdAt: item.createdAt,
            updatedAt: item.updatedAt,
            incidenciasPrevias: count,
          );
        }).toList();

        return state.copyWith(isLoading: false, data: listaProcesada);
      },
    );
  }
}