import 'package:crv_reprosisa/features/inspections/models/inspector_row_ui.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/table/app_table.dart';
import '../../../core/widgets/table/app_table_column.dart';

class TableInspector extends StatelessWidget {
  final List<InspectionRowUI> items;
  final ValueChanged<String> onSearch;

  const TableInspector({
    super.key,
    required this.items,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: onSearch,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search here...',
                border: InputBorder.none, 
              )  
            )
          ),
          AppTable<InspectionRowUI>(
            columns: const [
              AppTableColumn(label: 'ID'),
              AppTableColumn(label: 'Tipo'),
              AppTableColumn(label: 'Fecha'),
              AppTableColumn(label: 'Estado'),
               AppTableColumn(label: 'Acciones'),
            ],
            data: items,
            cellBuilder: (item, column) {
              switch (column.label) {
                case 'ID':
                  return Text(item.id);
                case 'Tipo':
                  return Text(item.equipment);
                case 'Fecha':
                  return Text(item.date);
                case 'Estado':
                  return Text(item.state);
                case 'Acciones':
                  return Text(item.state);
                default:
                  return const SizedBox.shrink();
              }
            },
          )
        ],
      ),
    );
  }
}