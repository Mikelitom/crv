import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PressServiceDetailView extends ConsumerStatefulWidget {
  final Press press;

  const PressServiceDetailView({super.key, required this.press});

  @override
  ConsumerState<PressServiceDetailView> createState() => _PressServiceDetailViewState();
}

class _PressServiceDetailViewState extends ConsumerState<PressServiceDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pressItemNotifierProvider.notifier).loadPendingItems(widget.press.id);
ref.read(pressIncidenceNotifierProvider.notifier).loadIncidences(widget.press.id);    
ref.read(pressServiceOrderNotifierProvider.notifier).loadOrders(widget.press.id);});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildContainer(child: _buildHeader(widget.press)),
            const SizedBox(height: 16),
            _buildSummarySection(), // Contadores KPI
            const SizedBox(height: 16),
            _buildSectionContainer("COMPONENTES", _buildComponentesList()),
            const SizedBox(height: 16),
            _buildSectionContainer("INSPECCIONES", _buildInspeccionesList()),
            const SizedBox(height: 16),
            _buildSectionContainer("ORDEN ABIERTA", _buildOrdenServicioCard()),
            const SizedBox(height: 16),
            _buildSectionContainer("INCIDENTES", _buildRecurrenciaSection()),
          ],
        ),
      ),
    );
  }

  // --- ESTRUCTURA ---
  Widget _buildContainer({required Widget child}) => Container(
    width: double.infinity,
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
    child: child,
  );

  Widget _buildSectionContainer(String title, Widget content) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
        const Divider(height: 24),
        content,
      ],
    ),
  );

// --- UI COMPONENTES (CON AGRUPAMIENTO DE INCIDENCIAS) ---
Widget _buildComponentesList() {
  final state = ref.watch(pressItemNotifierProvider);

  if (state.status == Status.loading) return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
  if (state.data.isEmpty) return const Padding(padding: EdgeInsets.all(20), child: Text("Sin componentes pendientes"));

  // Lógica de agrupamiento: Creamos un mapa para contar cuántas veces aparece cada nombre
  final Map<String, int> conteoIncidencias = {};
  for (var item in state.data) {
    conteoIncidencias[item.componentName] = (conteoIncidencias[item.componentName] ?? 0) + 1;
  }

  return ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: conteoIncidencias.length,
    separatorBuilder: (_, __) => const Divider(height: 1),
    itemBuilder: (context, index) {
      final name = conteoIncidencias.keys.elementAt(index);
      final count = conteoIncidencias[name]!;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text("Incidencias detectadas: $count", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
            // Un pequeño indicador visual del contador
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: Text("$count Veces", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10)),
            ),
          ],
        ),
      );
    },
  );
}

  // --- HEADER Y KPI ---
  Widget _buildHeader(Press p) => Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${p.model} - ${p.serie}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Estado: ${p.operationState}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC62828), foregroundColor: Colors.white),
          onPressed: () {},
          icon: const Icon(Icons.add, size: 16),
          label: const Text("ORDEN"),
        ),
      ],
    ),
  );

Widget _buildSummarySection() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    // Usamos MainAxisAlignment.spaceEvenly para que se distribuyan solos
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
      children: [
        Expanded(child: _counterCard("0", "Alertas", Colors.red)),
        const SizedBox(width: 8),
        Expanded(child: _counterCard("0", "Abierta", Colors.orange)),
        const SizedBox(width: 8),
        Expanded(child: _counterCard("0", "Total", Colors.blue)),
        const SizedBox(width: 8),
        Expanded(child: _counterCard("0", "Insp.", Colors.green)),
      ],
    ),
  );

  Widget _counterCard(String value, String label, Color color) => Container(
    // Aumentamos el padding vertical para que no se vea tan aplastado
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.white, 
      borderRadius: BorderRadius.circular(16), // Bordes más redondeados
      border: Border.all(color: color.withOpacity(0.3)), // Borde un poco más visible
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))
      ]
    ),
    child: Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
      ]
    ),
  );
  Widget _buildInspeccionesList() => const ListTile(title: Text("Sin inspecciones"), contentPadding: EdgeInsets.zero);
Widget _buildOrdenServicioCard() {
    final state = ref.watch(pressServiceOrderNotifierProvider);

    if (state.status == Status.loading) return const Center(child: CircularProgressIndicator());
    if (state.orders.isEmpty) return const Padding(padding: EdgeInsets.all(16), child: Text("No hay órdenes abiertas"));

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.orders.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final order = state.orders[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(order.description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          subtitle: Text("Estado: ${order.status} | Fecha: ${order.formattedDate}", style: const TextStyle(fontSize: 11)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        );
      },
    );
  }Widget _buildRecurrenciaSection() {
    final state = ref.watch(pressIncidenceNotifierProvider);

    if (state.status == Status.loading) return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
    if (state.incidences.isEmpty) return const Text("Sin incidencias registradas");

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.incidences.length,
      separatorBuilder: (_, __) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final item = state.incidences[index];
        // Normalizamos el progreso (asumiendo un máximo de 10 para visualización)
        final progress = (item.incidenceCount / 10).clamp(0.0, 1.0);
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.componentName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text("${item.incidenceCount} veces", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.purple)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress, color: Colors.purple, backgroundColor: Colors.purple.withOpacity(0.1)),
          ],
        );
      },
    );
  }}