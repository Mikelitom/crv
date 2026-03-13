import 'package:crv_reprosisa/features/activos/presentation/providers/press_list_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../activos/presentation/notifiers/press_list_notifier.dart';
import '../../../activos/presentation/states/status.dart';
import 'catalogo_data_table.dart'; // Tu componente genérico

class PressCatalogList extends ConsumerWidget {
  const PressCatalogList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pressState = ref.watch(pressListProvider);

    // 1. Si está cargando por primera vez
    if (pressState.status == Status.loading && pressState.press.isEmpty) {
      return const CatalogoDataTable(
        columnLabels: ["Modelo / Serie", "Volts", "Tamaño", "Estado", "Acciones"],
        emptyMessage: "Cargando prensas...",
        emptyIcon: Icons.refresh,
      );
    }

    // 2. Si la lista está vacía (Realmente no hay nada en la DB)
    if (pressState.press.isEmpty) {
      return const CatalogoDataTable(
        columnLabels: ["Modelo / Serie", "Volts", "Tamaño", "Estado", "Acciones"],
        emptyMessage: "No hay prensas registradas",
        emptyIcon: Icons.precision_manufacturing_outlined,
      );
    }

    // 3. Si hay datos, mostramos la tabla con las filas reales
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFECEFF1)),
      ),
      child: Column(
        children: [
          // Encabezado usando tu lógica de CatalogoDataTable
          _buildHeader(["Modelo / Serie", "Volts", "Tamaño", "Estado", "Acciones"]),
          
          // Filas dinámicas de la DB
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pressState.press.length,
            itemBuilder: (context, index) {
              final p = pressState.press[index];
              return _buildPressRow(p);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(List<String> labels) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration:  BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: labels.map((l) => Expanded(
          child: Text(l.toUpperCase(), 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF455A64))),
        )).toList(),
      ),
    );
  }

  Widget _buildPressRow(dynamic p) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFECEFF1))),
      ),
      child: Row(
        children: [
          Expanded(child: Text("${p.model} / ${p.serie}", style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(p.voltz)),
          Expanded(child: Text(p.size)),
          Expanded(child: _buildStatusTag(p.isActive)),
          Expanded(child: Row(
            children: [
              IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () {}),
              IconButton(icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red), onPressed: () {}),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildStatusTag(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(isActive ? "ACTIVA" : "MANTENIMIENTO",
        style: TextStyle(color: isActive ? Colors.green[800] : Colors.orange[800], fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}