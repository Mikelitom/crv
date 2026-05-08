import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/catalogo_notifier_provider.dart';
import '../states/catalogo_state.dart';
import '../../data/models/vehicle_catalog_model.dart';
import '../widgets/details_dialog.dart';

class VehicleTable extends ConsumerWidget {
  const VehicleTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(catalogoNotifierProvider);

    // LOADING
    if (state.status == CatalogoStatus.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // ERROR
    if (state.status == CatalogoStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text(
            state.errorMessage ?? 'Error al cargar vehículos',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // EMPTY
    if (state.vehicles.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Text(
            'No hay vehículos registrados',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

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
                  headingRowColor: WidgetStateProperty.all(
                    const Color(0xFFF8F9FA),
                  ),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'PLACA',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'RESPONSABLE',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'UBICACIÓN',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'ESTADO',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'ACCIONES',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: state.vehicles.map((vehicle) {
                    final bool isAvailable =
                        vehicle.state?.toUpperCase() == 'AVAILABLE';

                    final bool isWorkshop =
                        vehicle.state?.toUpperCase() == 'WORKSHOP';

                    return DataRow(
                      cells: [
                        // PLACA
                        DataCell(
                          Text(
                            vehicle.plate,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        // RESPONSABLE
                        DataCell(
                          Text(vehicle.responsible ?? 'Sin responsable'),
                        ),

                        // UBICACIÓN
                        DataCell(Text(vehicle.location ?? 'Sin ubicación')),

                        // ESTADO
                        DataCell(
                          _buildStatusChip(
                            isAvailable,
                            isWorkshop,
                            vehicle.state ?? 'SIN ESTADO',
                          ),
                        ),

                        // ACCIONES
                        DataCell(
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    VehicleDetailsDialog(vehicle: vehicle),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC62828),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "DETALLES",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(bool isAvailable, bool isWorkshop, String text) {
    Color color;

    if (isAvailable) {
      color = Colors.green;
    } else if (isWorkshop) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

