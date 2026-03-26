import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../assets/presentation/providers/vehicle_list_notifier_provider.dart';
import '../../../assets/presentation/states/status.dart';
class VehicleCatalogList extends ConsumerWidget {
  const VehicleCatalogList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleState = ref.watch(vehicleListProvider);

    // Manejo de carga inicial
    if (vehicleState.status == Status.loading && vehicleState.vehicles.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: CircularProgressIndicator(color: Color(0xFFC62828)),
        ),
      );
    }

    // Si la lista está vacía
    if (vehicleState.vehicles.isEmpty) {
      return _buildEmptyPlaceholder();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFECEFF1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
          columnSpacing: 24,
          dataRowMaxHeight: 70,
          columns: const [
            DataColumn(label: Text('MARCA / MODELO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            DataColumn(label: Text('PLACAS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            DataColumn(label: Text('AÑO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            DataColumn(label: Text('ESTADO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            DataColumn(label: Text('ACCIONES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          ],
          rows: vehicleState.vehicles.map((vehicle) {
            return DataRow(cells: [
              DataCell(Row(
                children: [
                  const Icon(Icons.directions_car_filled, color: Color(0xFFC62828), size: 18),
                  const SizedBox(width: 12),
                  Text("${vehicle.brand} ${vehicle.model}", style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              )),
              DataCell(Text(vehicle.licensePlate)),
              DataCell(Text(vehicle.year.toString())),
              DataCell(_buildStatusTag(vehicle.isActive)),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.blueGrey),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                    onPressed: () {},
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusTag(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isActive ? "OPERATIVO" : "EN TALLER",
        style: TextStyle(
          color: isActive ? const Color(0xFF2E7D32) : const Color(0xFFEF6C00),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text("No hay vehículos en el catálogo", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
