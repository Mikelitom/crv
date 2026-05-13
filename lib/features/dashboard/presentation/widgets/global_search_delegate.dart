import 'package:flutter/material.dart';

class GlobalSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Buscar en Reprosisa...';

  // Botón para limpiar la búsqueda
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  // Botón para regresar
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  // Resultados finales al presionar Enter
  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text("Buscando: $query"));
  }

  // Sugerencias mientras escribes (Aquí conectas con Supabase)
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text("Busca activos, folios o minas"));
    }

    // EJEMPLO DE RESULTADOS (Aquí deberías llamar a tu provider de búsqueda)
    final sugerencias = [
      {'tipo': 'Prensa', 'nombre': 'Prensa Hidráulica P-8821', 'icon': Icons.settings},
      {'tipo': 'Banda', 'nombre': 'Banda Transportadora B-1024', 'icon': Icons.settings_ethernet},
      {'tipo': 'Mina', 'nombre': 'Mina Buenavista del Cobre', 'icon': Icons.terrain},
    ].where((e) => e['nombre']!.toString().toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: sugerencias.length,
      itemBuilder: (context, index) {
        final item = sugerencias[index];
        return ListTile(
          leading: Icon(item['icon'] as IconData, color: const Color(0xFFC62828)),
          title: Text(item['nombre'] as String),
          subtitle: Text(item['tipo'] as String),
          onTap: () {
            // Aquí navegas al detalle del activo o reporte
            close(context, null);
          },
        );
      },
    );
  }
}