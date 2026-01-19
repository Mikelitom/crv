import 'package:flutter/material.dart';

class ReportFilters extends StatelessWidget {
  final bool isAdmin;
  final Function(String) onSearch;

  const ReportFilters({super.key, required this.isAdmin, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Filtros de Búsqueda", 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 20),
          if (isMobile) 
            Column(children: _buildFields(context)) 
          else 
            Row(children: _buildFields(context, isExpanded: true)),
        ],
      ),
    );
  }

  List<Widget> _buildFields(BuildContext context, {bool isExpanded = false}) {
    Widget wrap(Widget child) => isExpanded ? Expanded(child: child) : Padding(padding: const EdgeInsets.only(bottom: 16), child: child);

    return [
      wrap(TextField(
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: "Buscar reportes...",
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      )),
      if (isExpanded) const SizedBox(width: 16),
      wrap(_buildDropdown("Tipo de Reporte", ["Vehículo", "Prensa", "Banda"])),
      if (isExpanded) const SizedBox(width: 16),
      if (isAdmin) ...[
        wrap(_buildDropdown("Empleado", ["Juan Pérez", "María López"])),
        if (isExpanded) const SizedBox(width: 16),
      ],
      // Botón Aplicar Filtros
      SizedBox(
        height: 50,
        child: OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.filter_alt_outlined),
          label: const Text("Aplicar Filtros"),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFC62828),
            side: const BorderSide(color: Color(0xFFFDECEA)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    ];
  }

  Widget _buildDropdown(String hint, List<String> items) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) {},
    );
  }
}