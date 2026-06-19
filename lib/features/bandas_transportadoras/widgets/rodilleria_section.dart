import 'package:flutter/material.dart';

class RodilleriaSection extends StatefulWidget {
  const RodilleriaSection({super.key});

  @override
  State<RodilleriaSection> createState() => _RodilleriaSectionState();
}

class _RodilleriaSectionState extends State<RodilleriaSection> {
  // Matriz de 8 filas x 8 columnas
  final List<List<TextEditingController>> _controllers = List.generate(
    8, (_) => List.generate(8, (_) => TextEditingController()),
  );

  int cargaAcero = 0, impacto = 0, retorno = 0, soporte = 0;

  void _calcularTotales() {
    int nCarga = 0, nImpacto = 0, nRetorno = 0, nSoporte = 0;

    for (var row in _controllers) {
      // Regla: Izq (col 2), Central (col 3), Derecho (col 4) -> Carga Acero
      nCarga += (int.tryParse(row[2].text) ?? 0) + (int.tryParse(row[3].text) ?? 0) + (int.tryParse(row[4].text) ?? 0);
      // Regla: Impacto (col 5)
      nImpacto += int.tryParse(row[5].text) ?? 0;
      // Regla: Retorno (col 6)
      nRetorno += int.tryParse(row[6].text) ?? 0;
      // Regla: Soporte Triple (col 7)
      nSoporte += int.tryParse(row[7].text) ?? 0;
    }

    setState(() {
      cargaAcero = nCarga;
      impacto = nImpacto;
      retorno = nRetorno;
      soporte = nSoporte;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          _buildHeader(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(width: 1000, child: _buildTechnicalTable()),
          ),
          _buildInventorySummary(),
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
        ...List.generate(8, (i) => _buildDataRow(i)),
      ],
    );
  }

  TableRow _buildDataRow(int rowIndex) {
    return TableRow(
      children: List.generate(8, (colIndex) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _controllers[rowIndex][colIndex],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          onChanged: (value) => _calcularTotales(), // Dispara el cálculo
          decoration: const InputDecoration(isDense: true, border: UnderlineInputBorder()),
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
          Wrap(spacing: 20, runSpacing: 10, children: [
            _SummaryItem("RODILLO CARGA ACERO", "$cargaAcero"),
            _SummaryItem("RODILLO IMPACTO", "$impacto"),
            _SummaryItem("RODILLO RETORNO", "$retorno"),
            _SummaryItem("SOPORTE TRIPLE", "$soporte"),
          ]),
          const SizedBox(height: 20),
          const TextField(maxLines: 2, decoration: InputDecoration(labelText: "ACCIONES / OBSERVACIONES", filled: true, fillColor: Colors.white, border: OutlineInputBorder())),
        ],
      ),
    );
  }

  // --- MÉTODOS AUXILIARES ---
  Widget _buildHeader() { /* ... Tu diseño de Header ... */ return Container(); }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  const _HeaderCell(this.label);
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(12), child: Center(child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 9, color: Color(0xFF444444)))));
}

class _SummaryItem extends StatelessWidget {
  final String label, total;
  const _SummaryItem(this.label, this.total);
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
    Text("$total PIEZAS", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFC62828))),
  ]);
}