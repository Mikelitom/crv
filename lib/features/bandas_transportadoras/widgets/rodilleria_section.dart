import 'package:crv_reprosisa/features/bandas_transportadoras/presentation/provider/banda_inspection_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RodilleriaSection extends ConsumerStatefulWidget {
  const RodilleriaSection({super.key});

  @override
  ConsumerState<RodilleriaSection> createState() => _RodilleriaSectionState();
}

class _RodilleriaSectionState extends ConsumerState<RodilleriaSection> {
  // Cambiamos a 1 fila inicial para que sea dinámico
  final List<List<TextEditingController>> _rows = [];

  int cargaAcero = 0, impacto = 0, retorno = 0;

  void _calcular() {
    int nCarga = 0, nImp = 0, nRet = 0;

    for (var row in _rows) {
      int vIzq = int.tryParse(row[2].text) ?? 0;
      int vCen = int.tryParse(row[3].text) ?? 0;
      int vDer = int.tryParse(row[4].text) ?? 0;
      int vImp = int.tryParse(row[5].text) ?? 0;
      int vRet = int.tryParse(row[6].text) ?? 0;

      int posicionesActivas = 0;
      if (vIzq > 0) posicionesActivas++;
      if (vCen > 0) posicionesActivas++;
      if (vDer > 0) posicionesActivas++;

      if (vImp > 0) {
        nImp += posicionesActivas;
      } else if (vRet > 0) {
        nRet += posicionesActivas;
      } else {
        nCarga += posicionesActivas;
      }
    }

    if (mounted) {
      setState(() {
        cargaAcero = nCarga;
        impacto = nImp;
        retorno = nRet;
      });
    }
  }

  void _syncRollerToProvider(int index, List<TextEditingController> row) {
    ref
        .read(bandaInspectionProvider.notifier)
        .updateRoller(
          index,
          tableNumber: int.tryParse(row[0].text) ?? 0,
          baseNumber: int.tryParse(row[1].text) ?? 0,
          isLeft: row[2].text.isNotEmpty && int.tryParse(row[2].text)! > 0,
          isCenter: row[3].text.isNotEmpty && int.tryParse(row[3].text)! > 0,
          isRight: row[4].text.isNotEmpty && int.tryParse(row[4].text)! > 0,
          isImpact: row[5].text.isNotEmpty && int.tryParse(row[5].text)! > 0,
          isReturn: row[6].text.isNotEmpty && int.tryParse(row[6].text)! > 0,
          supportType: row[7].text,
          observation: row[8].text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
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
        const Text(
          "CONTROL DE RODILLERÍA",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.green, size: 30),
          onPressed: () => setState(() {
            _rows.add(List.generate(9, (_) => TextEditingController()));
            ref.read(bandaInspectionProvider.notifier).addRoller();
          }),
          
        ),
      ],
    ),
  );

  Widget _buildTechnicalTable() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(0.8),
          1: FlexColumnWidth(0.8),
          2: FlexColumnWidth(1.0),
          3: FlexColumnWidth(1.0),
          4: FlexColumnWidth(1.0),
          5: FlexColumnWidth(1.0),
          6: FlexColumnWidth(1.0),
          7: FlexColumnWidth(2.0),
          8: FlexColumnWidth(2.0),
        },
        border: TableBorder.all(color: Colors.grey.shade300),
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade100),
            children: [
              "No. Mesa",
              "No. Base",
              "IZQ",
              "CEN",
              "DER",
              "IMP",
              "RET",
              "TIPO SOPORTE",
              "OBS",
            ].map((e) => _HeaderCell(e)).toList(),
          ),
          ..._rows.asMap().entries.map(
            (e) => TableRow(
              children: [
                _input(e.value[0], e.key, e.value),
                _input(e.value[1], e.key, e.value),
                _input(e.value[2], e.key, e.value),
                _input(e.value[3], e.key, e.value),
                _input(e.value[4], e.key, e.value),
                _input(e.value[5], e.key, e.value),
                _input(e.value[6], e.key, e.value),
                _input(e.value[7], e.key, e.value),
                _input(e.value[8], e.key, e.value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(
    TextEditingController c,
    int index,
    List<TextEditingController> row,
  ) => SizedBox(
    height: 45,
    child: TextField(
      controller: c,
      textAlign: TextAlign.center,
      onChanged: (_) {
        _calcular();
        _syncRollerToProvider(index, row);
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 12),
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

// ... _HeaderCell y _SummaryItem se quedan igual ...
class _HeaderCell extends StatelessWidget {
  final String label;
  const _HeaderCell(this.label);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(10),
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 9),
    ),
  );
}

class _SummaryItem extends StatelessWidget {
  final String label, total;
  const _SummaryItem(this.label, this.total);
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
      Text(
        "$total PZ",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Colors.red,
        ),
      ),
    ],
  );
}
