import 'package:flutter/material.dart';
class TableInspector extends StatelessWidget {
  final List<Map<String, String>> data;
  const TableInspector({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        const ListTile(title: Text("Buscar"), subtitle: TextField(decoration: InputDecoration(hintText: "Search here...", prefixIcon: Icon(Icons.search)))),
        Table(
          children: [
            TableRow(decoration: BoxDecoration(color: Colors.grey.shade100), children: [
              const Padding(padding: EdgeInsets.all(12), child: Text("Inspección", style: TextStyle(fontWeight: FontWeight.bold))),
              const Padding(padding: EdgeInsets.all(12), child: Text("Nombre", style: TextStyle(fontWeight: FontWeight.bold))),
              const Padding(padding: EdgeInsets.all(12), child: Text("Acciones", style: TextStyle(fontWeight: FontWeight.bold))),
            ]),
            ...data.map((item) => TableRow(children: [
              Padding(padding: const EdgeInsets.all(12), child: Text(item['inspeccion']!)),
              Padding(padding: const EdgeInsets.all(12), child: Text(item['nombre']!)),
              Padding(padding: const EdgeInsets.all(12), child: Text(item['acciones']!, style: const TextStyle(color: Colors.grey))),
            ])),
          ],
        ),
      ]),
    );
  }
}