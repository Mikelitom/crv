import 'package:flutter/material.dart';

class RodilleriaSection extends StatefulWidget {
  const RodilleriaSection({super.key});

  @override
  State<RodilleriaSection> createState() => _RodilleriaSectionState();
}

class _RodilleriaSectionState extends State<RodilleriaSection> {
  List<List<TextEditingController>> _rows = List.generate(
    8, (_) => List.generate(8, (_) => TextEditingController()),
  );
  
  List<String> _tipos = List.generate(8, (_) => "Triple");
  int cargaAcero = 0, impacto = 0, retorno = 0;

  void _calcular() {
    int nCarga = 0, nImp = 0, nRet = 0;
    for (var row in _rows) {
      int izq = int.tryParse(row[2].text) ?? 0;
      int cen = int.tryParse(row[3].text) ?? 0;
      int der = int.tryParse(row[4].text) ?? 0;
      int imp = int.tryParse(row[5].text) ?? 0;
      int ret = int.tryParse(row[6].text) ?? 0;

      if (imp > 0) nImp += imp;
      else if (ret > 0) nRet += ret;
      else nCarga += (izq + cen + der);
    }
    if (mounted) setState(() { cargaAcero = nCarga; impacto = nImp; retorno = nRet; });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildTechnicalTable(),
          _buildInventorySummary(),
        ],
      ),
    );
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
      children: [
        const Icon(Icons.settings_applications, color: Colors.indigo, size: 28),
        const SizedBox(width: 12),
        const Text("CONTROL DE RODILLERÍA", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        const Spacer(),
        IconButton(icon: const Icon(Icons.add_circle, color: Colors.green, size: 30), onPressed: () => setState(() {
          _rows.add(List.generate(8, (_) => TextEditingController()));
          _tipos.add("Triple");
        })),
      ],
    ),
  );

  Widget _buildTechnicalTable() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1), 1: FlexColumnWidth(1), 2: FlexColumnWidth(1.2),
          3: FlexColumnWidth(1.2), 4: FlexColumnWidth(1.2), 5: FlexColumnWidth(1.2),
          6: FlexColumnWidth(1.2), 7: FlexColumnWidth(2.5), 8: FlexColumnWidth(2),
        },
        border: TableBorder.all(color: Colors.grey.shade300),
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade100),
            children: ["No. Mesa", "No. Base", "Izquierdo", "Central", "Derecho", "Impacto", "Retorno", "Soporte Triple o Autoalineable", "Comentarios"]
                .map((e) => _HeaderCell(e)).toList(),
          ),
          ..._rows.asMap().entries.map((e) => TableRow(children: [
            _input(e.value[0]), _input(e.value[1]), _input(e.value[2]),
            _input(e.value[3]), _input(e.value[4]), _input(e.value[5]),
            _input(e.value[6]), _typeSelector(e.key), _input(e.value[7]),
          ])),
        ],
      ),
    );
  }

  Widget _input(TextEditingController c) => SizedBox(
    height: 45,
    child: TextField(
      controller: c,
      textAlign: TextAlign.center,
      onChanged: (_) => _calcular(),
      decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 12)),
    ),
  );

  Widget _typeSelector(int index) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _tipos[index],
        isExpanded: true,
        style: const TextStyle(fontSize: 10, color: Colors.indigo, fontWeight: FontWeight.bold),
        items: ["Triple", "Auto"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => setState(() => _tipos[index] = v!),
      ),
    ),
  );

  Widget _buildInventorySummary() => Container(
    padding: const EdgeInsets.all(25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SummaryItem("CARGA ACERO", "$cargaAcero"),
        _SummaryItem("IMPACTO", "$impacto"),
        _SummaryItem("RETORNO", "$retorno"),
      ],
    ),
  );
}

class _HeaderCell extends StatelessWidget {
  final String label;
  const _HeaderCell(this.label);
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(10), child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 9)));
}

class _SummaryItem extends StatelessWidget {
  final String label, total;
  const _SummaryItem(this.label, this.total);
  @override Widget build(BuildContext context) => Column(children: [
    Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
    Text("$total PZ", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.red)),
  ]);
}