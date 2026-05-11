import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/catalogo_notifier_provider.dart';
import '../../data/models/vehicle_state_model.dart';
import '../widgets/details_dialog.dart';

class VehicleTable extends ConsumerWidget {
  const VehicleTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // LISTA ESTÁTICA DETALLADA
    final List<Map<String, dynamic>> staticVehicles = [
      {
        'id': 'V-001',
        'plate': 'SON-442-A', 
        'resp': 'JUAN PÉREZ SOTO', 
        'loc': 'PLANTA REPROSISA', 
        'active': true, 
        'status_text': 'EN USO',
        'out_time': '07:00 AM'
      },
      {
        'id': 'V-002',
        'plate': 'SON-110-B', 
        'resp': 'TALLER MECÁNICO "GARCÍA"', 
        'loc': 'CALLE 12 SUR #45', 
        'active': false, 
        'status_text': 'EN TALLER',
        'out_time': '09:15 AM'
      },
      {
        'id': 'V-003',
        'plate': 'SON-998-C', 
        'resp': 'CARLOS VILLA', 
        'loc': 'MINA LA CARIDAD', 
        'active': true, 
        'status_text': 'EN USO',
        'out_time': '06:30 AM'
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFECEFF1)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  columnSpacing: 30,
                  headingRowHeight: 56,
                  dataRowMaxHeight: 70,
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
                  columns: const [
                    DataColumn(label: Text('PLACA', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('RESPONSABLE / TALLER', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('UBICACIÓN', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('ESTADO', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('ACCIONES', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: staticVehicles.map((v) {
                    return DataRow(cells: [
                      DataCell(Text(v['plate'], style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(v['resp'])),
                      DataCell(Text(v['loc'])),
                      DataCell(_buildStatusChip(v['active'], v['status_text'])),
                      DataCell(
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => VehicleDetailsDialog(
                                vehicle: VehicleStateModel(
                                  id: v['id'], // CAMBIO AQUÍ: Ya no falta el ID
                                  plate: v['plate'],
                                  responsibleName: v['resp'],
                                  isActive: v['active'],
                                  location: v['loc'],
                                  mileage: 12500,
                                  checkout: DateTime.now(),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC62828),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("DETALLES", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(bool isActive, String text) {
    Color color = isActive ? Colors.green : (text == 'EN TALLER' ? Colors.orange : Colors.red);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}