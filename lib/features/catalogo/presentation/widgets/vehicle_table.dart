import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/catalogo_notifier_provider.dart';
import '../widgets/details_dialog.dart';

class VehicleTable extends ConsumerWidget {
  const VehicleTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(catalogoNotifierProvider);
    final vehicles = state.filteredVehicles;

    if (vehicles.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Text("No hay datos disponibles", style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    // Usamos LayoutBuilder para saber cuánto espacio tenemos disponible
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
              // Forzamos un ancho mínimo para que la tabla no se colapse
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  // ESPACIADO DINÁMICO: Ajusta las columnas según el tamaño
                  columnSpacing: constraints.maxWidth < 600 ? 20 : 40,
                  headingRowHeight: 56,
                  dataRowMaxHeight: 70,
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
                  columns: const [
                    DataColumn(label: Text('PLACA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                    DataColumn(label: Text('RESPONSABLE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                    DataColumn(label: Text('UBICACIÓN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                    DataColumn(label: Text('ESTADO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                    DataColumn(label: Text('ACCIONES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                  ],
                  rows: vehicles.map((v) {

                    return DataRow(cells: [
                      // Placa: Negrita y tamaño fijo
                      DataCell(Text(v.plate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),

                      // Responsable: Con límite de ancho para que no empuje las otras columnas
                      DataCell(
                        Container(
                          constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.3),
                          child: Text(
                            v.responsibleName,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),

                      // Ubicación
                      DataCell(Text(v.location ?? 'En Patio', style: const TextStyle(fontSize: 13))),

                      // Estado (Chip)
                      DataCell(_buildStatusChip(v.isActive)),

                      // Botón
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => VehicleDetailsDialog(vehicle: v)
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC62828),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text("VER MÁS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
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

  Widget _buildStatusChip(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? const Color(0xFF2E7D32).withOpacity(0.2) : const Color(0xFFC62828).withOpacity(0.2)
        ),
      ),
      child: Text(
        isActive ? "ACTIVO" : "INACTIVO",
        style: TextStyle(
          color: isActive ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
