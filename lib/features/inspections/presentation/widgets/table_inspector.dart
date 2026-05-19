import 'package:flutter/material.dart';
import '../models/inspector_row_ui.dart';

class TableInspector extends StatefulWidget {
  final List<InspectionRowUI> items;

  const TableInspector({super.key, required this.items});

  @override
  State<TableInspector> createState() => _TableInspectorState();
}

class _TableInspectorState extends State<TableInspector> {
  final Color primaryRed = const Color(0xFFC62828);
  final Color headerColor = const Color(0xFFF9FAFB);
  final Color borderColor = const Color(0xFFE5E7EB);

  // Mapa para controlar el índice de la versión seleccionada por cada grupo de reporte
  final Map<String, int> selectedVersionMap = {};

  // Agrupamos los reportes normalizando el título para colapsar las versiones en una sola fila
  Map<String, List<InspectionRowUI>> get groupedInspections {
    Map<String, List<InspectionRowUI>> groups = {};
    
    // Expresión regular para detectar y remover " v1", " v2", " v3", etc. al final del título
    final versionRegex = RegExp(r'\s+v\d+$', caseSensitive: false);

    for (var item in widget.items) {
      // Limpiamos el título para agrupar bajo la misma clave base (ej: "Reporte Banda")
      final normalizedTitle = item.title.replaceAll(versionRegex, '').trim();
      
      groups.putIfAbsent(normalizedTitle, () => []).add(item);
    }
    
    // Ordenamos las listas de cada grupo de la versión más nueva (mayor) a la más vieja (menor)
    groups.forEach((key, list) {
      list.sort((a, b) => b.versionNumber.compareTo(a.versionNumber));
    });
    
    return groups;
  }

  // --- FUNCIONES DE ACCIÓN ---
  void _viewReport(BuildContext context, InspectionRowUI item) => print("Ver: ${item.id}");
  void _printReport(BuildContext context, InspectionRowUI item) => print("Imprimir: ${item.folio}");
  void _editReport(BuildContext context, InspectionRowUI item) => print("Editar: ${item.id}");

  @override
  Widget build(BuildContext context) {
    final groups = groupedInspections;

    if (groups.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(child: Text("No hay registros disponibles", style: TextStyle(color: Colors.grey))),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) return _buildMobileList(groups);
        return _buildDesktopTable(constraints.maxWidth, groups);
      },
    );
  }

  // --- DISEÑO ESCRITORIO ---
  Widget _buildDesktopTable(double maxWidth, Map<String, List<InspectionRowUI>> groups) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: maxWidth),
            child: DataTable(
              headingRowHeight: 52,
              dataRowMaxHeight: 85, 
              horizontalMargin: 20,
              columnSpacing: 20,
              headingRowColor: WidgetStateProperty.all(headerColor),
              showCheckboxColumn: false,
              columns: [
                DataColumn(label: _HeaderLabel(text: 'REPORTE', color: const Color(0xFF4B5563))),
                // Columna TIPO removida para coincidir con tu diseño limpio de Inventario
                DataColumn(label: _HeaderLabel(text: 'ESTADO', color: const Color(0xFF4B5563))),
                DataColumn(label: _HeaderLabel(text: 'FECHA', color: const Color(0xFF4B5563))),
                DataColumn(label: _HeaderLabel(text: 'ACCIONES', color: const Color(0xFF4B5563))),
              ],
              rows: groups.entries.map((entry) {
                int selectedIdx = selectedVersionMap[entry.key] ?? 0;
                
                if (selectedIdx >= entry.value.length) {
                  selectedIdx = 0;
                }
                
                var currentItem = entry.value[selectedIdx];
                return _buildDataRow(context, currentItem, entry.value, entry.key, selectedIdx);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(BuildContext context, InspectionRowUI item, List<InspectionRowUI> versions, String groupKey, int currentIdx) {
    return DataRow(
      cells: [
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    groupKey, // Título base sin duplicados estáticos
                    style: const TextStyle(
                      fontWeight: FontWeight.w800, 
                      fontSize: 13, 
                      color: Color(0xFF111827),
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(width: 10),
                  // 🔥 El Badge interactivo Dropdown estilizado tipo Placas Corporativas
                  _buildVersionDropdown(versions, groupKey, currentIdx),
                ],
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text(
                  item.description, 
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500), 
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        DataCell(_StatusBadge(state: item.state, label: item.translatedState)),
        DataCell(Text(item.date, style: const TextStyle(fontSize: 12, color: Colors.black54))),
        DataCell(Row(
          children: [
            _ActionIconBtn(icon: Icons.visibility_outlined, color: const Color(0xFF6366F1), onTap: () => _viewReport(context, item)),
            const SizedBox(width: 8),
            _ActionIconBtn(icon: Icons.edit_outlined, color: const Color(0xFF4B5563), onTap: () => _editReport(context, item)),
            const SizedBox(width: 8),
            _ActionIconBtn(icon: Icons.print_outlined, color: primaryRed, onTap: () => _printReport(context, item)),
          ],
        )),
      ],
    );
  }

  // 🔥 Selector interactivo tipo Dropdown (Borde rojo, flechita, cambia los datos de la fila completa)
  Widget _buildVersionDropdown(List<InspectionRowUI> versions, String key, int currentIdx) {
    return PopupMenuButton<int>(
      tooltip: "Seleccionar versión",
      padding: EdgeInsets.zero,
      offset: const Offset(0, 32),
      enabled: versions.length > 1, // Deshabilitado si solo existe una versión
      onSelected: (idx) {
        setState(() {
          selectedVersionMap[key] = idx;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFBFBFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: versions.length > 1 ? primaryRed : const Color(0xFFD1D5DB),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "v${versions[currentIdx].versionNumber}",
              style: TextStyle(
                color: versions.length > 1 ? primaryRed : const Color(0xFF4B5563),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down_circle_outlined,
              size: 14,
              color: versions.length > 1 ? primaryRed : const Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => versions.asMap().entries.map((e) {
        final bool isSelected = e.key == currentIdx;
        return PopupMenuItem<int>(
          value: e.key,
          height: 38,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Versión ${e.value.versionNumber}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected ? primaryRed : const Color(0xFF1F2937),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_rounded, size: 14, color: primaryRed),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- DISEÑO MÓVIL ---
  Widget _buildMobileList(Map<String, List<InspectionRowUI>> groups) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groups.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        String key = groups.keys.elementAt(index);
        List<InspectionRowUI> versions = groups[key]!;
        int current = selectedVersionMap[key] ?? 0;
        if (current >= versions.length) current = 0;
        var item = versions[current];

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), 
            side: BorderSide(color: borderColor), 
          ),
          child: ExpansionTile(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
            collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
            leading: Icon(Icons.assignment_outlined, color: primaryRed),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    key, 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                  ),
                ),
                _buildVersionDropdown(versions, key, current),
              ],
            ),
            subtitle: Text(item.translatedReportType, style: const TextStyle(fontSize: 12)),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _mobileRow("Folio", item.folio),
                    _mobileRow("Estado", item.translatedState, isStatus: true, rawState: item.state),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _mBtnMobile("Ver", Icons.visibility, const Color(0xFF6366F1), () => _viewReport(context, item)),
                        _mBtnMobile("Imprimir", Icons.print, primaryRed, () => _printReport(context, item)),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _mobileRow(String l, String v, {bool isStatus = false, String rawState = ""}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          isStatus ? _StatusBadge(state: rawState, label: v) : Text(v, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _mBtnMobile(String l, IconData i, Color c, VoidCallback t) => TextButton.icon(
    onPressed: t,
    icon: Icon(i, size: 18, color: c),
    label: Text(l, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.bold)),
  );
}

class _StatusBadge extends StatelessWidget {
  final String state;
  final String label;
  const _StatusBadge({required this.state, required this.label});

  @override
  Widget build(BuildContext context) {
    bool isCompleted = state.toUpperCase().contains('COMPLET') || label.toUpperCase().contains('COMPLET');
    Color baseColor = isCompleted ? const Color(0xFF059669) : const Color(0xFFD97706);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: baseColor.withOpacity(0.08), 
          borderRadius: BorderRadius.circular(20), 
          border: Border.all(color: baseColor.withOpacity(0.2))),
      child: Text(label, style: TextStyle(color: baseColor, fontSize: 10, fontWeight: FontWeight.w800)),
    );
  }
}

class _HeaderLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _HeaderLabel({required this.text, required this.color});
  @override
  Widget build(BuildContext context) => Text(text, style: TextStyle(fontWeight: FontWeight.w800, color: color, fontSize: 11, letterSpacing: 0.5));
}

class _ActionIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionIconBtn({required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 18),
      ),
    ),
  );
}