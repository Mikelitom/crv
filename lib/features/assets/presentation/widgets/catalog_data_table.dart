import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_status_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_notifier_providers.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_actions_providers.dart';
import 'asset_detail_modal.dart';

class CatalogDataTable extends ConsumerWidget {
  final List<dynamic> items;
  final String type;
  final Color primaryRed;
  final Function(dynamic) onEdit;
  final Function(dynamic, bool) onToggleStatus;

  const CatalogDataTable({
    super.key,
    required this.items,
    required this.type,
    required this.primaryRed,
    required this.onEdit,
    required this.onToggleStatus,
  });

  dynamic _getProperty(dynamic item, String key) {
    if (item is Map) return item[key] ?? '-';
    try {
      if (key == 'name') return item.name ?? '-';
      if (key == 'company') return item.company ?? '-';
      if (key == 'email') return item.email ?? '-';
      if (key == 'plate') return item.plate ?? '-';
      if (key == 'brand') return item.brand ?? '-';
      if (key == 'model') return item.model ?? '-';
      if (key == 'year') return item.year?.toString() ?? '-';
      if (key == 'serie') return item.serie ?? '-';
      if (key == 'size') return item.size ?? '-';
      if (key == 'type') return item.type ?? '-';
      if (key == 'operationState') return item.operationState ?? 'Disponible';
      if (key == 'currentLocation') return (type != 'cliente') ? (item.currentLocation ?? '-') : '-';
    } catch (_) { return '-'; }
    return '-';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (MediaQuery.of(context).size.width < 850) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) => _buildMobileCard(context, ref, items[index]),
      );
    }
    return _buildDesktopTable(context, ref);
  }

  Widget _buildMobileCard(BuildContext context, WidgetRef ref, dynamic item) {
    final bool isActive = item.isActive ?? true;
    final String title = type == "vehiculo" ? _getProperty(item, 'plate') : (type == "cliente" ? _getProperty(item, 'name') : _getProperty(item, 'serie'));
    final String subtitle = type == "vehiculo" ? "${_getProperty(item, 'brand')} ${_getProperty(item, 'model')}" : (type == "cliente" ? _getProperty(item, 'company') : _getProperty(item, 'model'));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ExpansionTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: primaryRed)),
        subtitle: Text(subtitle),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (type == "cliente") ...[
                  _buildMobileRow("Compañía", _getProperty(item, 'company')),
                  _buildMobileRow("Email", _getProperty(item, 'email')),
                ] else ...[
                  if (type == "vehiculo") _buildMobileRow("Año", _getProperty(item, 'year')),
                  if (type == "prensa") ...[_buildMobileRow("Tamaño", _getProperty(item, 'size')), _buildMobileRow("Tipo", _getProperty(item, 'type'))],
                  _buildMobileRow("Estado", "", custom: _buildStatusBadge(_getProperty(item, 'operationState'))),
                  _buildMobileRow("Ubicación", _getProperty(item, 'currentLocation')),
                ],
                const Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  _buildActionButton(Icons.visibility_rounded, Colors.green.shade50, Colors.green, () => showDialog(context: context, builder: (_) => AssetDetailModal(item: item, type: type, primaryRed: primaryRed))),
                  const SizedBox(width: 8),
                  _buildActionButton(Icons.edit_rounded, Colors.blue.shade50, Colors.blue, () => onEdit(item)),
                  const SizedBox(width: 8),
                  _buildStatusToggle(isActive, () => _handleToggle(ref, item, isActive, context)),
                ])
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMobileRow(String label, String value, {Widget? custom}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(width: 8),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: custom ?? Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
      ],
    ),
  );

  Widget _buildDesktopTable(BuildContext context, WidgetRef ref) {
    const s = TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF374151), fontSize: 12);
    final cs = TextStyle(color: Colors.blueGrey.shade900, fontSize: 13, fontWeight: FontWeight.w600);
    
    List<DataColumn> cols = type == "cliente" 
      ? [const DataColumn(label: Text("NOMBRE", style: s)), const DataColumn(label: Text("COMPAÑÍA", style: s)), const DataColumn(label: Text("E-MAIL", style: s)), const DataColumn(label: Text("ACCIONES", style: s))] 
      : type == "vehiculo" 
        ? [const DataColumn(label: Text("PLACA", style: s)), const DataColumn(label: Text("MODELO", style: s)), const DataColumn(label: Text("AÑO", style: s)), const DataColumn(label: Text("ESTADO", style: s)), const DataColumn(label: Text("UBICACIÓN", style: s)), const DataColumn(label: Text("ACCIONES", style: s))] 
        : [const DataColumn(label: Text("SERIE", style: s)), const DataColumn(label: Text("TAMAÑO", style: s)), const DataColumn(label: Text("TIPO", style: s)), const DataColumn(label: Text("MODELO", style: s)), const DataColumn(label: Text("ESTADO", style: s)), const DataColumn(label: Text("UBICACIÓN", style: s)), const DataColumn(label: Text("ACCIONES", style: s))];
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              columnSpacing: 30,
              dataRowMaxHeight: 60,
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
              columns: cols,
              rows: items.map((item) => DataRow(
                color: WidgetStateProperty.all((item.isActive ?? true) ? Colors.white : Colors.grey.shade100),
                cells: _getDesktopCells(context, ref, item, cs)
              )).toList(),
            ),
          ),
        );
      },
    );
  }

  List<DataCell> _getDesktopCells(BuildContext ctx, WidgetRef ref, dynamic item, TextStyle cs) {
    List<DataCell> cells = type == "cliente" 
      ? [DataCell(Text(_getProperty(item, 'name'), style: cs)), DataCell(Text(_getProperty(item, 'company'), style: cs)), DataCell(Text(_getProperty(item, 'email'), style: cs))] 
      : type == "vehiculo" 
        ? [DataCell(_buildIdentifierCell(_getProperty(item, 'plate'))), DataCell(Text("${_getProperty(item, 'brand')} ${_getProperty(item, 'model')}", style: cs)), DataCell(Text(_getProperty(item, 'year'), style: cs)), DataCell(_buildStatusBadge(_getProperty(item, 'operationState'))), DataCell(Text(_getProperty(item, 'currentLocation'), style: cs))] 
        : [DataCell(_buildIdentifierCell(_getProperty(item, 'serie'))), DataCell(Text(_getProperty(item, 'size'), style: cs)), DataCell(Text(_getProperty(item, 'type'), style: cs)), DataCell(Text(_getProperty(item, 'model'), style: cs)), DataCell(_buildStatusBadge(_getProperty(item, 'operationState'))), DataCell(Text(_getProperty(item, 'currentLocation'), style: cs))];
    
    cells.add(DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
      _buildActionButton(Icons.visibility_rounded, Colors.green.shade50, Colors.green, () => showDialog(context: ctx, builder: (_) => AssetDetailModal(item: item, type: type, primaryRed: primaryRed))),
      const SizedBox(width: 8),
      _buildActionButton(Icons.edit_rounded, Colors.blue.shade50, Colors.blue, () => onEdit(item)),
      const SizedBox(width: 8),
      _buildStatusToggle(item.isActive ?? true, () => _handleToggle(ref, item, item.isActive ?? true, ctx)),
    ])));
    return cells;
  }

  Widget _buildIdentifierCell(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: primaryRed.withOpacity(0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: primaryRed.withOpacity(0.3))),
    child: Text(text, style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, color: primaryRed, fontSize: 13)),
  );

  Widget _buildStatusBadge(String s) {
    bool isAvailable = (s == "Disponible" || s == "AVAILABLE");
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: isAvailable ? Colors.green.shade100 : Colors.amber.shade100, borderRadius: BorderRadius.circular(12)),
      child: Text(s.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: isAvailable ? Colors.green.shade800 : Colors.amber.shade900)),
    );
  }

  Future<void> _handleToggle(WidgetRef ref, dynamic item, bool isActive, BuildContext context) async {
    final String itemId = (type == "vehiculo") ? (item.vehicleId ?? "") : (item.id ?? "");
    if (itemId.isEmpty) return;
    bool eraActivo = isActive;
    if (type == "vehiculo") { eraActivo ? await ref.read(deactivateVehicleProvider.notifier).deactivate(itemId) : await ref.read(activateVehicleProvider.notifier).activate(itemId); ref.read(vehicleListProvider.notifier).loadVehicles(); }
    else if (type == "prensa") { eraActivo ? await ref.read(deactivatePressProvider.notifier).deactivate(itemId) : await ref.read(activatePressProvider.notifier).activate(itemId); ref.read(pressListProvider.notifier).loadPress(); }
    else { eraActivo ? await ref.read(deleteClientProvider.notifier).delete(itemId) : await ref.read(activateClientProvider.notifier).activate(itemId); ref.read(clientListProvider.notifier).loadClients(); }
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Estado actualizado")));
  }

  Widget _buildStatusToggle(bool isActive, VoidCallback onTap) => GestureDetector(onTap: onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 300), width: 40, height: 22, padding: const EdgeInsets.all(2), decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: isActive ? Colors.green : Colors.grey), child: AnimatedAlign(duration: const Duration(milliseconds: 300), alignment: isActive ? Alignment.centerRight : Alignment.centerLeft, child: Container(width: 18, height: 18, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)))));
  Widget _buildActionButton(IconData icon, Color b, Color c, VoidCallback onTap) => InkWell(onTap: onTap, child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: b, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: c, size: 16)));
}