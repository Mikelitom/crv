import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_history_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class HistoryInspectionsFeed extends ConsumerWidget {
  const HistoryInspectionsFeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pressHistoryProvider);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Historial de Inspecciones", 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          // Lógica de consumo de estado reutilizado
          if (state.status == Status.loading)
            const Center(child: CircularProgressIndicator())
          else if (state.status == Status.error)
            Center(child: Text("Error: ${state.error}"))
          else if (state.history.isEmpty)
            const Center(child: Text("No hay inspecciones registradas."))
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.history.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final h = state.history[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Folio: ${h.folio}", 
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${h.inspectionDate.toString().split(' ')[0]} • Área: ${h.area}"),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(h.state, style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}