import 'package:flutter/material.dart';

class LastMovementsWidget extends StatelessWidget {
  // Datos estáticos de ejemplo
  final List<Map<String, String>> movements = [
    {"serie": "SN-333", "tipo": "Mantenimiento", "estado": "Completado", "fecha": "08 Jul 2026", "hora": "14:30", "usuario": "Miguel Angel"},
    {"serie": "SN-102", "tipo": "Préstamo", "estado": "En Uso", "fecha": "08 Jul 2026", "hora": "12:15", "usuario": "Juan Pérez"},
    {"serie": "SN-500", "tipo": "Inspección", "estado": "Pendiente", "fecha": "07 Jul 2026", "hora": "09:00", "usuario": "Ana López"},
    {"serie": "SN-221", "tipo": "Devolución", "estado": "Disponible", "fecha": "07 Jul 2026", "hora": "16:45", "usuario": "Carlos Ruiz"},
  ];

  LastMovementsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Últimos Movimientos", 
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF1A1A1A))),
          Container(height: 4, width: 40, margin: const EdgeInsets.only(top: 6), color: const Color(0xFFC62828)),
          const SizedBox(height: 24),
          
          // Tabla Responsiva
          LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  columnSpacing: 30,
                  headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  columns: const [
                    DataColumn(label: Text("Serie")),
                    DataColumn(label: Text("Tipo")),
                    DataColumn(label: Text("Estado")),
                    DataColumn(label: Text("Fecha/Hora")),
                    DataColumn(label: Text("Usuario")),
                  ],
                  rows: movements.map((m) => DataRow(cells: [
                    DataCell(Text(m['serie']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(m['tipo']!)),
                    DataCell(_buildStatusChip(m['estado']!)),
                    DataCell(Text("${m['fecha']} ${m['hora']}")),
                    DataCell(Text(m['usuario']!)),
                  ])).toList(),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = status == "Completado" ? Colors.green : (status == "En Uso" ? Colors.blue : Colors.orange);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}