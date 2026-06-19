import 'package:flutter/material.dart';
import '../../page/vehiculos/vehicle_history_page.dart';

class ServiceDataTable extends StatelessWidget {
  final bool isVehiculo;
  const ServiceDataTable({super.key, required this.isVehiculo});

  @override
  Widget build(BuildContext context) {
    // Datos estáticos con la estructura solicitada
    final data = [
      {'id': 'SON-442-A', 'km': '9,800', 'hallazgos': 3, 'prox': '10,000 km', 'estado': 'Atención'},
      {'id': 'SON-110-B', 'km': '4,200', 'hallazgos': 0, 'prox': '5,000 km', 'estado': 'Normal'},
      {'id': 'SON-998-C', 'km': '14,800', 'hallazgos': 5, 'prox': '15,000 km', 'estado': 'Crítico'},
    ];

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFF1F3F5))),
      child: Column(
        children: [
          _headerRow(),
          ...data.map((item) => _buildRow(context, item)),
        ],
      ),
    );
  }

  Widget _headerRow() => Container(
    padding: const EdgeInsets.all(28),
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF1F3F5)))),
    child: const Row(children: [
      Expanded(child: Text("UNIDAD", style: TextStyle(fontWeight: FontWeight.bold))),
      Expanded(child: Text("KM ACTUAL")),
      Expanded(child: Text("HALLAZGOS")),
      Expanded(child: Text("PRÓXIMO SERV.")),
      Expanded(child: Text("ESTADO")),
      Expanded(child: Text("ACCIONES")),
    ]),
  );

  Widget _buildRow(BuildContext context, Map<String, dynamic> item) {
    Color color = item['estado'] == 'Crítico' ? Colors.red : (item['estado'] == 'Atención' ? Colors.orange : Colors.green);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF1F3F5)))),
      child: Row(children: [
        Expanded(child: Text(item['id'], style: const TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text(item['km'])),
        Expanded(child: Text("${item['hallazgos']}")),
        Expanded(child: Text(item['prox'])),
        Expanded(child: _statusChip(item['estado'], color)),
        Expanded(child: TextButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleHistoryPage(vehicleId: item['id']))),
          child: const Text("Ver", style: TextStyle(fontWeight: FontWeight.bold)),
        )),
      ]),
    );
  }

  Widget _statusChip(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
    child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
  );
}