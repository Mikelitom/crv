import 'package:flutter/material.dart';
class TableInspector extends StatelessWidget {
  final List<String> columnHeaders;
  final List<List<String>> rows;
  final Function(String) onSearch;

  const TableInspector({
    super.key, 
    required this.columnHeaders, 
    required this.rows,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: onSearch,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search here...",
                border: InputBorder.none,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
              columns: columnHeaders.map((header) => DataColumn(label: Text(header, style: const TextStyle(fontWeight: FontWeight.bold)))).toList(),
              rows: rows.map((row) => DataRow(
                cells: row.map((cell) => DataCell(Text(cell))).toList(),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}