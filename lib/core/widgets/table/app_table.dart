import 'package:flutter/material.dart';
import 'app_table_column.dart';

class AppTable<T> extends StatelessWidget {
  final List<AppTableColumn<T>> columns;
  final List<T> data;
  final Widget Function(T item, AppTableColumn<T> column) cellBuilder;
  final Widget? emptyState;

  const AppTable({
    super.key,
    required this.columns,
    required this.data,
    required this.cellBuilder,
    this.emptyState,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return emptyState ?? const Center(child: Text('Sin datos'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
            ),
            child: DataTable(
              columnSpacing: 24,
              headingRowHeight: 48,
              dataRowMinHeight: 48,
              dataRowMaxHeight: 56,
              columns: columns
                  .map(
                    (c) => DataColumn(
                      label: Text(
                        c.label,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      numeric: c.isNumeric,
                    ),
                  )
                  .toList(),
              rows: data.map((item) {
                return DataRow(
                  cells: columns
                      .map(
                        (col) => DataCell(
                          cellBuilder(item, col),
                        ),
                      )
                      .toList(),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
