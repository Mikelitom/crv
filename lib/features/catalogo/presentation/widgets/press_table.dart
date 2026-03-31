import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/catalogo_notifier_provider.dart';
// ESTE IMPORT ES VITAL PARA QUE RECONOZCA SOLICITANTSNAME, STATUS, ETC.
import '../../data/models/press_loan_model.dart'; 

class PressTable extends ConsumerWidget {
  const PressTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(catalogoNotifierProvider);
    final List<PressLoanModel> loans = state.presses; 

    if (loans.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "No hay préstamos de prensas registrados",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      );
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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text('ID PRENSA', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('SOLICITANTE', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ÁREA', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('PRÉSTAMO', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('RETORNO EXP.', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ESTADO', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ACCIONES', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: loans.map((l) {
              return DataRow(cells: [
                // Cortamos el ID si es muy largo (UUID)
                DataCell(Text(l.pressId.length > 8 ? "${l.pressId.substring(0, 8)}..." : l.pressId)),
                
                DataCell(Text(l.solicitantsName ?? 'N/A')),
                
                DataCell(Text(l.area ?? 'S/A')),
                
                // Formateo simple de fecha (YYYY-MM-DD)
                DataCell(Text(l.loanDate != null 
                    ? l.loanDate!.toString().split(' ').first 
                    : "-")),
                
                DataCell(Text(l.expectedReturnDate != null 
                    ? l.expectedReturnDate!.toString().split(' ').first 
                    : "-")),
                
                DataCell(_buildStatusChip(l.status ?? "pendiente")),
                
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.blueGrey, size: 20),
                      onPressed: () {
                        // Implementar edición de préstamo
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.assignment_return_outlined, color: Colors.blue, size: 20),
                      onPressed: () {
                        // Implementar devolución de prensa
                      },
                    ),
                  ],
                )),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = Colors.orange;
    String label = status.toUpperCase();

    if (label == 'DEVUELTO' || label == 'COMPLETO') {
      color = Colors.green;
    } else if (label == 'ATRASADO') {
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}