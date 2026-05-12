import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/client_mine.dart';
import '../presentation/provider/banda_inspection_providers.dart';



class CustomerSection extends ConsumerWidget {
  const CustomerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bandaInspectionProvider);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Cliente", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            hint: const Text("Seleccione Cliente"),
            // Validación para evitar error de aserción
            value: state.clients.any((c) => c.id == state.selectedClient?.id) 
                ? state.selectedClient?.id 
                : null,
            items: state.clients.map<DropdownMenuItem<String>>((Client client) {
              return DropdownMenuItem<String>(value: client.id, child: Text(client.company));
            }).toList(),
            onChanged: (id) {
              if (id != null) {
                final client = state.clients.firstWhere((c) => c.id == id);
                ref.read(bandaInspectionProvider.notifier).selectClient(client);
              }
            },
          ),
        ],
      ),
    );
  }
}