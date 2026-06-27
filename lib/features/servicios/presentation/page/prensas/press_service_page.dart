import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/press/press_service_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PressServicePage extends ConsumerStatefulWidget {
  const PressServicePage({super.key});

  @override
  ConsumerState<PressServicePage> createState() => _PressServicePageState();
}

class _PressServicePageState extends ConsumerState<PressServicePage> {
  Press? selectedPress;
  bool isPanelOpen = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pressListProvider.notifier).loadPress();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pressListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: Stack(
        children: [
          // PANEL DERECHO: Detalle (Uso de operador seguro ?? para evitar el error '!')
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: selectedPress == null
                  ? const Center(child: Text("Selecciona un activo"))
                  : PressServiceDetailView(
                      key: ValueKey(selectedPress!.id), 
                      press: selectedPress!,
                    ),
            ),
          ),

          // PANEL IZQUIERDO: Flotante
          if (isPanelOpen)
            Positioned(
              left: 16, top: 16, bottom: 80, width: 350,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(16), 
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16), 
                      child: TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: "Buscar...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))))
                    ),
                    Expanded(
                      child: state.status == Status.loading 
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: state.press.length,
                            itemBuilder: (context, index) {
                              final v = state.press[index];
                              return InkWell(
                                onTap: () {
                                  // Usamos un pequeño delay o simplemente el setState directo
                                  setState(() {
                                    selectedPress = v;
                                    isPanelOpen = false;
                                  });
                                },
                                child: _buildCompactPressTile(v, selectedPress?.id == v.id),
                              );
                            },
                          ),
                    ),
                  ],
                ),
              ),
            ),
          
          // BOTÓN FLOTANTE
          Positioned(
            left: 16, bottom: 16,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFFC62828),
              elevation: 4,
              onPressed: () => setState(() => isPanelOpen = !isPanelOpen),
              child: Icon(isPanelOpen ? Icons.close : Icons.list, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactPressTile(Press v, bool isSelected) {
    Color statusColor = v.operationState == "WORKSHOP" ? Colors.orange : Colors.blue;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.red.withOpacity(0.05) : Colors.transparent, 
        border: Border(bottom: BorderSide(color: Colors.grey[200]!))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [const Icon(Icons.precision_manufacturing, size: 16), const SizedBox(width: 8), Text(v.serie, style: const TextStyle(fontWeight: FontWeight.bold))]),
            _buildCompactBadge(v.model, statusColor),
          ]),
          Text("${v.serie} ${v.model}", style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCompactBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), 
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), 
      child: Text(status, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold))
    );
  }
}