import 'package:flutter/material.dart';

class ReportFilters extends StatelessWidget {
  final bool isAdmin;
  final Function(String) onSearch;
  final Function(String?) onStatusFilter;

  const ReportFilters({
    super.key, 
    required this.isAdmin, 
    required this.onSearch, 
    required this.onStatusFilter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Filtros y Búsqueda", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Row(
            children: [
              // Buscador dinámico
              Expanded(
                flex: 2,
                child: TextField(
                  onChanged: onSearch,
                  decoration: InputDecoration(
                    hintText: "Buscar reporte...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Filtro de Estado (Aprobado, Pendiente, etc)
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Estado"),
                  items: ["Aprobado", "Pendiente", "Rechazado"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: onStatusFilter,
                ),
              ),
              // Solo el Admin ve filtros de empleados
              if (isAdmin) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Empleado"),
                    items: ["Juan Perez", "Carlos Ruiz", "Maria Lopez"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => print("Filtrando por empleado: $val"),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}