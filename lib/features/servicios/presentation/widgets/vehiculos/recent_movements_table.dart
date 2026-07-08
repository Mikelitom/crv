import 'package:flutter/material.dart';

class RecentMovementsTable extends StatelessWidget {
  final List<dynamic> vehicles;
  final String searchQuery; // Pasamos el buscador para filtrar aquí

  const RecentMovementsTable({
    super.key, 
    required this.vehicles,
    this.searchQuery = "",
  });

  @override
  Widget build(BuildContext context) {
    // Filtramos los vehículos según la búsqueda
    final filtered = vehicles.where((v) => 
      v.plate.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 700;

        return Container(
          margin: const EdgeInsets.only(top: 24),
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Últimos movimientos", 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              isMobile 
                ? _buildMobileList(filtered) 
                : _buildDesktopTable(filtered),
            ],
          ),
        );
      },
    );
  }

  // --- MODO DESKTOP: TABLA ORIGINAL ---
  Widget _buildDesktopTable(List<dynamic> filtered) {
    return Table(
      columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2), 2: FlexColumnWidth(1), 3: FlexColumnWidth(1.5), 4: FlexColumnWidth(1.5)},
      children: [
        TableRow(children: ["PLACA", "ACTIVO", "ESTADO", "FECHA Y HORA", "USUARIO"].map((h) => 
          Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(h, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)))).toList()),
        ...filtered.take(10).map((v) => TableRow(children: [
          Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(v.plate, style: const TextStyle(fontWeight: FontWeight.bold))),
          Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text("${v.brand} ${v.model}")),
          Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(v.operationState)),
          Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: const Text("06/07/2026 11:52 AM")),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text("Miguel Fajardo")),
        ])),
      ],
    );
  }

  // --- MODO MÓVIL: LISTA DE TARJETAS ---
  Widget _buildMobileList(List<dynamic> filtered) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.take(10).length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, i) {
        final v = filtered[i];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(v.plate, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("${v.brand} ${v.model} • ${v.operationState}"),
          trailing: const Icon(Icons.chevron_right),
        );
      },
    );
  }
}