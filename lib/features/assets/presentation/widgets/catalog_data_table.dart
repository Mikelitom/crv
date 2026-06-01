import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_list_notifier_provider.dart'; // Import nuevo
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_status_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_notifier_providers.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_actions_providers.dart'; // Import nuevo
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const headerStyle = TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF374151), fontSize: 12, letterSpacing: 0.5);
    final cellStyle = TextStyle(color: Colors.blueGrey.shade900, fontSize: 13, fontWeight: FontWeight.w600);

    List<DataColumn> columns = [];
    if (type == "cliente") {
      columns = [
        DataColumn(label: Text("NOMBRE", style: headerStyle)),
        DataColumn(label: Text("COMPAÑÍA", style: headerStyle)),
        DataColumn(label: Text("E-MAIL", style: headerStyle)),
        DataColumn(label: Text("ACCIONES", style: headerStyle)),
      ];
    } else if (type == "vehiculo") {
      columns = [
        DataColumn(label: Text("PLACA", style: headerStyle)),
        DataColumn(label: Text("MARCA / MODELO", style: headerStyle)),
        DataColumn(label: Text("AÑO", style: headerStyle)),
        DataColumn(label: Text("ESTADO OPERATIVO", style: headerStyle)),
        DataColumn(label: Text("UBICACIÓN", style: headerStyle)),
        DataColumn(label: Text("ACCIONES", style: headerStyle)),
      ];
    } else {
      columns = [
        DataColumn(label: Text("SERIE", style: headerStyle)),
        DataColumn(label: Text("TAMAÑO", style: headerStyle)),
        DataColumn(label: Text("TIPO", style: headerStyle)),
        DataColumn(label: Text("MODELO", style: headerStyle)),
        DataColumn(label: Text("ESTADO OPERATIVO", style: headerStyle)),
        DataColumn(label: Text("UBICACIÓN", style: headerStyle)),
        DataColumn(label: Text("ACCIONES", style: headerStyle)),
      ];
    }

    return SizedBox(
      width: double.infinity,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.grey.withOpacity(0.08)),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
          dataRowMaxHeight: 64,
          headingRowHeight: 52,
          horizontalMargin: 24,
          columnSpacing: 16,
          showCheckboxColumn: false,
          columns: columns,
          rows: items.map((item) {
            final String state = (type == "vehiculo" || type == "prensa") ? (item.operationState ?? 'Disponible') : '';
            final String pressType = type == "prensa" ? (item.type ?? 'Mechanical') : '';
            final bool isFija = pressType.toLowerCase().contains('hydrau') || pressType.toLowerCase().contains('fija');
            final bool isActive = item.isActive ?? true;
            
            final String itemId = (type == "vehiculo") 
                ? (item.vehicleId ?? "") 
                : (item.id ?? ""); 

            return DataRow(
              color: WidgetStateProperty.all(isActive ? Colors.white : Colors.grey.shade100),
              cells: [
                if (type == "cliente") ...[
                  DataCell(Opacity(opacity: isActive ? 1.0 : 0.5, child: Text(item.name ?? "-", style: cellStyle.copyWith(color: const Color(0xFF111827))))),
                  DataCell(Text(item.company ?? "-", style: cellStyle)),
                  DataCell(Text(item.email ?? "-", style: cellStyle)),
                ] else if (type == "vehiculo") ...[
                  DataCell(Opacity(opacity: isActive ? 1.0 : 0.5, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(6)), child: Text(item.plate ?? "-", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: primaryRed, letterSpacing: 0.5))))),
                  DataCell(Text("${item.brand ?? '-'} ${item.model ?? '-'}", style: cellStyle)),
                  DataCell(Text(item.year?.toString() ?? "-", style: cellStyle)),
                  DataCell(_buildStatusBadge(state)),
                  DataCell(Text(item.currentLocation ?? "-", style: cellStyle)),
                ] else ...[
                  DataCell(Text(item.serie ?? "-", style: cellStyle.copyWith(color: primaryRed, fontWeight: FontWeight.w800))),
                  DataCell(Text(item.size ?? "-", style: cellStyle)),
                  DataCell(Text(isFija ? "Hidráulica (Fija)" : "Mecánica (Móvil)", style: cellStyle)),
                  DataCell(Text(isFija ? "-" : (item.model ?? "-"), style: cellStyle)),
                  DataCell(_buildStatusBadge(state)),
                  DataCell(Text(item.currentLocation ?? "-", style: cellStyle)),
                ],
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildActionButton(Icons.visibility_rounded, const Color(0xFFE8F5E9), const Color(0xFF2E7D32), () {
                        showDialog(context: context, builder: (context) => AssetDetailModal(item: item, type: type, primaryRed: primaryRed));
                      }),
                      const SizedBox(width: 8),
                      _buildActionButton(Icons.edit_rounded, const Color(0xFFE3F2FD), const Color(0xFF2196F3), () {
                        onEdit(item);
                      }),
                      const SizedBox(width: 8),
                      _buildActionButton(
                        isActive ? Icons.block_rounded : Icons.check_circle_outline, 
                        isActive ? const Color(0xFFFFEBEE) : const Color(0xFFE8F5E9), 
                        isActive ? primaryRed : Colors.green, 
                        () async {
                          if (itemId.isNotEmpty) {
                            String nombre = type == "vehiculo" ? "Vehículo" : (type == "prensa" ? "Prensa" : "Cliente");
                            bool eraActivo = isActive;

                            if (type == "vehiculo") {
                              eraActivo ? await ref.read(deactivateVehicleProvider.notifier).deactivate(itemId)
                                        : await ref.read(activateVehicleProvider.notifier).activate(itemId);
                              ref.read(vehicleListProvider.notifier).loadVehicles();
                            } else if (type == "prensa") {
                              eraActivo ? await ref.read(deactivatePressProvider.notifier).deactivate(itemId)
                                        : await ref.read(activatePressProvider.notifier).activate(itemId);
                              ref.read(pressListProvider.notifier).loadPress();
                            } else if (type == "cliente") {
                              eraActivo ? await ref.read(deleteClientProvider.notifier).delete(itemId)
                                        : await ref.read(activateClientProvider.notifier).activate(itemId);
                              ref.read(clientListProvider.notifier).loadClients();
                            } else {
                              onToggleStatus(item, !isActive);
                            }
                            
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("$nombre ${eraActivo ? 'desactivado' : 'activado'} con éxito"),
                                  backgroundColor: eraActivo ? Colors.red.shade600 : Colors.green.shade600,
                                ),
                              );
                            }
                          } else {
                            onToggleStatus(item, !isActive);
                          }
                        }
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor = const Color(0xFFE8F5E9);
    Color textColor = const Color(0xFF2E7D32);

    if (status != "Disponible" && status != "AVAILABLE") {
      bgColor = const Color(0xFFFFF3E0);
      textColor = const Color(0xFFEF6C00);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Text(status.toUpperCase(), style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w900)),
    );
  }

  Widget _buildActionButton(IconData icon, Color bgColor, Color iconColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(height: 32, width: 32, decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: iconColor, size: 16)),
    );
  }
}