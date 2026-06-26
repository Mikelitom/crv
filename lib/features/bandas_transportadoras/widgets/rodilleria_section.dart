import 'package:crv_reprosisa/features/bandas_transportadoras/presentation/provider/banda_inspection_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RodilleriaSection extends ConsumerStatefulWidget {
  const RodilleriaSection({super.key});

  @override
  ConsumerState<RodilleriaSection> createState() => _RodilleriaSectionState();
}

class _RodilleriaSectionState extends ConsumerState<RodilleriaSection> {
  final List<List<TextEditingController>> _rows = [];
  late TextEditingController _notesController;
  int cargaAcero = 0, impacto = 0, retorno = 0;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: ref.read(bandaInspectionProvider).rollerNotes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _calcular() {
    int nCarga = 0, nImp = 0, nRet = 0;
    for (var row in _rows) {
      int vIzq = int.tryParse(row[2].text) ?? 0;
      int vCen = int.tryParse(row[3].text) ?? 0;
      int vDer = int.tryParse(row[4].text) ?? 0;
      int vImp = int.tryParse(row[5].text) ?? 0;
      int vRet = int.tryParse(row[6].text) ?? 0;
      int posicionesActivas = (vIzq > 0 ? 1 : 0) + (vCen > 0 ? 1 : 0) + (vDer > 0 ? 1 : 0);
      if (vImp > 0) nImp += posicionesActivas;
      else if (vRet > 0) nRet += posicionesActivas;
      else nCarga += posicionesActivas;
    }
    if (mounted) setState(() { cargaAcero = nCarga; impacto = nImp; retorno = nRet; });
  }

  void _syncRollerToProvider(int index, List<TextEditingController> row) {
    ref.read(bandaInspectionProvider.notifier).updateRoller(
      index,
      tableNumber: int.tryParse(row[0].text) ?? 0,
      baseNumber: int.tryParse(row[1].text) ?? 0,
      isLeft: (int.tryParse(row[2].text) ?? 0) > 0,
      isCenter: (int.tryParse(row[3].text) ?? 0) > 0,
      isRight: (int.tryParse(row[4].text) ?? 0) > 0,
      isImpact: (int.tryParse(row[5].text) ?? 0) > 0,
      isReturn: (int.tryParse(row[6].text) ?? 0) > 0,
      supportType: row[7].text,
      observation: row[8].text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bandaInspectionProvider);
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15)]),
      child: Column(
        children: [
          _buildHeader(),
          LayoutBuilder(builder: (context, constraints) {
            return constraints.maxWidth < 600 ? _buildMobileView() : _buildTechnicalTable();
          }),
          _buildInventorySummary(),
          _buildNotesSection(state.rollerNotes),
        ],
      ),
    );
  }

  // --- MODO MÓVIL: Estilo Tabla Compacta ---
  Widget _buildMobileView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _rows.length,
      itemBuilder: (context, index) {
        final row = _rows[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              Row(children: [_cell("Mesa", row[0], index, row, isHeader: true), _cell("Base", row[1], index, row, isHeader: true)]),
              Row(children: [_cell("IZQ", row[2], index, row), _cell("CEN", row[3], index, row), _cell("DER", row[4], index, row), _cell("IMP", row[5], index, row), _cell("RET", row[6], index, row)]),
              _field("Tipo Soporte", row[7], index, row),
              _field("Observaciones", row[8], index, row),
            ],
          ),
        );
      },
    );
  }

  Widget _cell(String label, TextEditingController c, int idx, List<TextEditingController> row, {bool isHeader = false}) => Expanded(
    child: Container(
      decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.shade300), bottom: BorderSide(color: Colors.grey.shade300)), color: isHeader ? Colors.grey.shade100 : null),
      child: TextField(
        controller: c, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(hintText: label, border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 10)),
        onChanged: (_) { _calcular(); _syncRollerToProvider(idx, row); },
      ),
    ),
  );

Widget _field(String label, TextEditingController c, int idx, List<TextEditingController> row) => TextField(
    controller: c,
    style: const TextStyle(fontSize: 12),
    decoration: InputDecoration(
      labelText: label,
      // Color uniforme de borde
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.indigo.shade300, width: 2), // Un toque sutil al enfocar
      ),
      filled: true,
      fillColor: Colors.white, // Fondo blanco para que combine con las celdas
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    ),
    onChanged: (_) { _calcular(); _syncRollerToProvider(idx, row); },
  );

  // --- MODO ESCRITORIO ---
  Widget _buildTechnicalTable() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        children: [
          TableRow(decoration: BoxDecoration(color: Colors.grey.shade100), children: ["No. Mesa", "No. Base", "IZQ", "CEN", "DER", "IMP", "RET", "TIPO SOPORTE", "OBS"].map((e) => _HeaderCell(e)).toList()),
          ..._rows.asMap().entries.map((e) => TableRow(children: List.generate(9, (i) => _input(e.value[i], e.key, e.value)))),
        ],
      ),
    );
  }

  Widget _input(TextEditingController c, int index, List<TextEditingController> row) => TextField(
    controller: c, textAlign: TextAlign.center, onChanged: (_) { _calcular(); _syncRollerToProvider(index, row); },
    decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(8)),
  );

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.all(20),
    child: Row(children: [
      const Icon(Icons.settings_applications, color: Colors.indigo, size: 28),
      const SizedBox(width: 12),
      Expanded(child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: const Text("CONTROL DE RODILLERÍA", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)))),
      IconButton(icon: const Icon(Icons.add_circle, color: Colors.green, size: 30), onPressed: () => setState(() { _rows.add(List.generate(9, (_) => TextEditingController())); ref.read(bandaInspectionProvider.notifier).addRoller(); })),
    ]),
  );

Widget _buildNotesSection(String currentNotes) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("COMENTARIOS DE RODILLERÍA", 
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFF0F172A))),
      const SizedBox(height: 10),
      TextFormField(
        controller: _notesController,
        maxLines: 3,
        style: const TextStyle(fontSize: 13),
        onChanged: (v) => ref.read(bandaInspectionProvider.notifier).updateRollerNotes(v),
        decoration: InputDecoration(
          hintText: "Escribe notas...",
          // Mismo borde exacto que la tabla
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    ]),
  );

  Widget _buildInventorySummary() => Container(
    padding: const EdgeInsets.all(25),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      _SummaryItem("CARGA ACERO", "$cargaAcero"),
      _SummaryItem("IMPACTO", "$impacto"),
      _SummaryItem("RETORNO", "$retorno"),
    ]),
  );
}

class _HeaderCell extends StatelessWidget {
  final String label;
  const _HeaderCell(this.label);
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(10), child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 9)));
}

class _SummaryItem extends StatelessWidget {
  final String label, total;
  const _SummaryItem(this.label, this.total);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
    Text("$total PZ", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.red)),
  ]);
}