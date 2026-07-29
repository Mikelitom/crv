import 'package:crv_reprosisa/features/servicios/data/models/vehiculos/pending_component_entity_v.dart' show PendingComponentModelV;
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/pending_componenet_state_v.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/pending_component_provider_v.dart';
import 'package:flutter/foundation.dart';
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
        // Diagnóstico para verificar si la API trae todos los registros históricos o si vienen filtrados
        debugPrint("Total registros obtenidos de la API: ${data.length}");
        for (final item in data) {
          debugPrint("ID: ${item.componentId} | Nombre: ${item.componentName} | Opción: ${item.selectedOption}");
        }

        final Map<String, int> conteoFrecuencia = {};
        final Map<String, PendingComponentModelV> unicos = {};

        // Agrupamos utilizando componentId para evitar problemas de variaciones en el nombre
        for (var item in data) {
          final option = item.selectedOption.toLowerCase().trim()
              .replaceAll('ó', 'o')
              .replaceAll('á', 'a')
              .replaceAll('é', 'e')
              .replaceAll('í', 'i')
              .replaceAll('ú', 'u');
          
          if (option.contains('mala') || 
              option.contains('reposicion') || 
              option.contains('reparacion')) {
            
            conteoFrecuencia[item.componentId] = (conteoFrecuencia[item.componentId] ?? 0) + 1;
            unicos[item.componentId] = item as PendingComponentModelV;
          }
        }

        // Construimos la lista procesada usando el entry.key que ahora es el componentId
        final listaProcesada = unicos.entries.map((entry) {
          final compId = entry.key;
          final item = entry.value;
          
          int count = conteoFrecuencia[compId] ?? 1;
          
          String nuevoStatus = 'PENDIENTE';
          if (count > 3) nuevoStatus = 'CRÍTICO';
          else if (count > 1) nuevoStatus = 'ATENCIÓN';

          return PendingComponentModelV(
            id: item.id,
            vehicleId: item.vehicleId,
            serviceId: item.serviceId,
            componentId: compId,
            componentName: item.componentName,
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