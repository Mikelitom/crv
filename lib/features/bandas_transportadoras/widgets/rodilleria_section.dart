import 'package:flutter/material.dart';

class RodilleriaSection extends StatelessWidget {
  const RodilleriaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          // Scroll horizontal para tablet/laptop para evitar cortes en las columnas del Excel
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000, 
              child: _buildTechnicalTable(),
            ),
          ),
          _buildInventorySummary(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFFBFBFB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFC62828), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.settings_input_component, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("SECCIÓN ESPECIAL", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
              Text("Rodillería", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalTable() {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(80), 1: FixedColumnWidth(80), 
        2: FlexColumnWidth(1), 3: FlexColumnWidth(1), 4: FlexColumnWidth(1),
        5: FlexColumnWidth(1), 6: FlexColumnWidth(1), 7: FlexColumnWidth(2),
      },
      border: TableBorder.all(color: Colors.grey.shade100),
      children: [
        const TableRow(
          decoration: BoxDecoration(color: Color(0xFFF1F4F9)),
          children: [
            _HeaderCell("No. MESA"), _HeaderCell("No. BASE"),
            _HeaderCell("IZQ."), _HeaderCell("CENT."), _HeaderCell("DER."),
            _HeaderCell("IMPACTO"), _HeaderCell("RETORNO"), _HeaderCell("SOPORTE TRIPLE"),
          ],
        ),
        ...List.generate(8, (index) => _buildDataRow()), // Filas basadas en el Excel
      ],
    );
  }

  TableRow _buildDataRow() {
    return TableRow(
      children: List.generate(8, (index) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(isDense: true, border: UnderlineInputBorder(), hintText: "0"),
        ),
      )),
    );
  }

  Widget _buildInventorySummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("RESUMEN DE REPUESTOS (TOTALES)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 20, runSpacing: 10,
            children: [
              _SummaryItem("RODILLO CARGA ACERO", "5"),
              _SummaryItem("RODILLO IMPACTO", "0"),
              _SummaryItem("RODILLO RETORNO", "1"),
              _SummaryItem("SOPORTE TRIPLE", "1"),
            ],
          ),
          const SizedBox(height: 20),
          const TextField(maxLines: 2, decoration: InputDecoration(labelText: "ACCIONES / OBSERVACIONES", filled: true, fillColor: Colors.white, border: OutlineInputBorder())),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  const _HeaderCell(this.label);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(12),
    child: Center(child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 9, color: Color(0xFF444444)))),
  );
}

class _SummaryItem extends StatelessWidget {
  final String label, total;
  const _SummaryItem(this.label, this.total);
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
      Text("$total PIEZAS", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFC62828))),
    ],
  );
}