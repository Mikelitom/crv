import 'package:flutter/material.dart';
import '../widgets/press_detail_dialog.dart';
class PressTable extends StatelessWidget {
  const PressTable({super.key});

  @override
  Widget build(BuildContext context) {
    // DATOS ESTÁTICOS COMPLETOS PARA PRENSAS
    final List<Map<String, String>> staticPressLoans = [
      {
        'id': 'PRN-2024-001',
        'sol': 'ING. RICARDO LOERA',
        'area': 'MANTENIMIENTO MINA',
        'fecha': '10/05/2024',
        'retorno': '15/05/2024',
        'estado': 'EN CURSO',
        'contacto': '662-555-0199'
      },
      {
        'id': 'PRN-2024-045',
        'sol': 'TEC. MARIO SANDOVAL',
        'area': 'PRODUCCIÓN A',
        'fecha': '01/05/2024',
        'retorno': '05/05/2024',
        'estado': 'ATRASADO',
        'contacto': '662-555-0244'
      },
      {
        'id': 'PRN-2024-012',
        'sol': 'SISTEMA AUTOMÁTICO',
        'area': 'TALLER CENTRAL',
        'fecha': '12/05/2024',
        'retorno': '20/05/2024',
        'estado': 'PENDIENTE',
        'contacto': 'N/A'
      },
    ];

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
              DataColumn(label: Text('ESTADO', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('ACCIONES', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: staticPressLoans.map((l) {
              return DataRow(cells: [
                DataCell(Text(l['id']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(l['sol']!)),
                DataCell(Text(l['area']!)),
                DataCell(_buildStatusChip(l['estado']!)),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.blueGrey, size: 20),
                      onPressed: () {
                        // AQUÍ SE ABRE EL DIÁLOGO TIPO LA IMAGEN QUE PASASTE
                        showDialog(
                          context: context,
                          builder: (context) => PressDetailsDialog(press: l),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.assignment_return_outlined, color: Colors.blue, size: 20),
                      onPressed: () {
                        // Lógica para devolver prensa
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

    if (label == 'COMPLETO' || label == 'DEVUELTO') {
      color = Colors.green;
    } else if (label == 'ATRASADO') {
      color = Colors.red;
    } else if (label == 'EN CURSO') {
      color = Colors.blue;
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