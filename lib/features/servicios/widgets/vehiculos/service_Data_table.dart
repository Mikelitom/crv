import 'package:flutter/material.dart';
// Asegúrate de que estas rutas apunten a tus archivos de historial

import '../../page/prensas/press_history_page.dart';
import '../../page/vehiculos/vehicle_history_page.dart';

class ServiceDataTable extends StatelessWidget {
  final bool isVehiculo;

  ServiceDataTable({super.key, required this.isVehiculo});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> data = isVehiculo ? [
      {'id': 'SON-442-A', 'folio': 'SRV-2026-001', 'estado': 'EN PROCESO', 'taller': 'Taller García'},
      {'id': 'SON-110-B', 'folio': 'SRV-2026-005', 'estado': 'PENDIENTE', 'taller': 'Servicio Express'},
      {'id': 'SON-998-C', 'folio': 'SRV-2026-009', 'estado': 'FINALIZADO', 'taller': 'Agencia Toyota'},
    ] : [
      {'id': 'PRENSA-01', 'folio': 'MAQ-2026-99', 'estado': 'REPARACIÓN', 'taller': 'Mantenimiento Interno'},
      {'id': 'PRENSA-45', 'folio': 'MAQ-2026-102', 'estado': 'PREVENTIVO', 'taller': 'Taller Hidráulico'},
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F3F5), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                _header('IDENTIFICADOR', flex: 2),
                _header('FOLIO', flex: 2),
                _header('TALLER / DEP.', flex: 2),
                _header('ESTADO', flex: 2),
                _header('ACCIONES', flex: 3),
              ],
            ),
          ),
          ...data.map((item) => _buildRow(context, item)),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, Map<String, String> item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF1F3F5)))),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(item['id']!, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text(item['folio']!, style: const TextStyle(color: Colors.blueGrey))),
          Expanded(flex: 2, child: Text(item['taller']!, style: const TextStyle(color: Colors.grey, fontSize: 12))),
          Expanded(flex: 2, child: _statusChip(item['estado']!)),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.visibility_outlined, size: 20), onPressed: () {}),
                const SizedBox(width: 12),
                // BOTÓN DE EXPEDIENTE CON NAVEGACIÓN
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC62828).withOpacity(0.1),
                    foregroundColor: const Color(0xFFC62828),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => isVehiculo 
                          ? VehicleHistoryPage(vehicleId: item['id']!) 
                          : PressHistoryPage(pressId: item['id']!),
                      ),
                    );
                  },
                  child: const Text("EXPEDIENTE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String s) {
    Color c = s == 'FINALIZADO' ? Colors.green : (s == 'PENDIENTE' ? Colors.orange : Colors.blue);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(s, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _header(String t, {int flex = 1}) => Expanded(flex: flex, child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.blueGrey)));
}