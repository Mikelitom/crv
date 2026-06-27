import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/press/press_info_card.dart';
import 'package:flutter/material.dart';

class PressServiceDetailView extends StatelessWidget {
  final Press press;

  const PressServiceDetailView({super.key, required this.press});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. HEADER (Título y botones de acción)
        _buildHeader(),

        // 2. TARJETA DE INFO (KPIs y datos generales)
        PressInfoCard(press: press),

        const SizedBox(height: 24),

        // 3. CUERPO DEL DASHBOARD
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              // Usamos IntrinsicHeight para que los 3 contenedores tengan el mismo alto
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _buildSection("Componentes", Icons.engineering, Colors.red, _buildComponentesList())),
                    const SizedBox(width: 16),
                    Expanded(child: _buildSection("Inspecciones", Icons.history, Colors.blue, _buildInspeccionesList())),
                    const SizedBox(width: 16),
                    Expanded(child: _buildSection("Orden Abierta", Icons.assignment, Colors.orange, _buildOrdenServicioCard())),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // SECCIÓN DE RECURRENCIA (Ocupa el ancho completo)
              _buildRecurrenciaSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  // --- WIDGETS DE ESTRUCTURA ---

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Detalle de Unidad", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Row(
            children: [
              OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.picture_as_pdf), label: const Text("Exportar")),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC62828), foregroundColor: Colors.white),
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text("NUEVA ORDEN"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Color color, Widget content) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [Icon(icon, color: color, size: 20), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))],
            ),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(8.0), child: content),
        ],
      ),
    );
  }

  // --- CONTENIDO DE SECCIONES ---

  Widget _buildComponentesList() {
    return Column(
      children: [
        _buildListTile("Filtro de aceite", "Incidencias previas: 3", true),
        _buildListTile("Banda de accesorios", "Incidencias previas: 1", false),
      ],
    );
  }

  Widget _buildListTile(String title, String subtitle, bool isCritical) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: isCritical ? Colors.red : Colors.orange, borderRadius: BorderRadius.circular(4)),
        child: Text(isCritical ? "CRÍTICO" : "ATENCIÓN", style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildInspeccionesList() => const ListTile(
    title: Text("15/06/2026", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
    subtitle: Text("Realizado por: M. Fajardo", style: TextStyle(fontSize: 11)),
    leading: Icon(Icons.check_circle, color: Colors.green, size: 20),
  );

  Widget _buildOrdenServicioCard() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("OS-2026-005", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
              child: const Text("IN_PROGRESS", style: TextStyle(color: Colors.blue, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text("Taller: Toyota Mérida | Apertura: 18/06/2026", style: TextStyle(fontSize: 11)),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: () {}, child: const Text("COMPLETAR")),
        const Divider(height: 30),
        const Align(alignment: Alignment.centerLeft, child: Text("Historial reciente:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
      ],
    );
  }

  Widget _buildRecurrenciaSection() {
    final incidencias = [
      {'name': 'Filtro de aceite', 'veces': 5},
      {'name': 'Balatas', 'veces': 3},
      {'name': 'Banda de accesorios', 'veces': 2},
    ];
  
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [Icon(Icons.trending_up, color: Colors.purple, size: 20), SizedBox(width: 8), Text("Incidencias más recurrentes", style: TextStyle(fontWeight: FontWeight.bold))]),
          const Divider(height: 30),
          ...incidencias.map((i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(i['name'] as String, style: const TextStyle(fontSize: 12)),
                  Text("${i['veces']} veces", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ]),
                const SizedBox(height: 6),
                LinearProgressIndicator(value: (i['veces'] as int) / 6, backgroundColor: Colors.grey[100], color: Colors.purple),
              ],
            ),
          )),
        ],
      ),
    );
  }
}