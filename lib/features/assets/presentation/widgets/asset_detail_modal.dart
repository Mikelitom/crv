import 'package:crv_reprosisa/features/assets/presentation/pages/client_history_page.dart';
import 'package:crv_reprosisa/features/assets/presentation/pages/press_history_page.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_actions_providers.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_history_provider.dart';
import '../pages/history_page_vehicle.dart';

class AssetDetailModal extends ConsumerWidget {
  final dynamic item;
  final String type; // "vehiculo", "prensa", "cliente"
  final Color primaryRed;

  const AssetDetailModal({
    super.key,
    required this.item,
    required this.primaryRed,
    required this.type,
  });

  /// Acceso seguro a las propiedades del objeto/mapa
  dynamic _val(String key) {
    if (item is Map) return item[key];
    try {
      if (key == 'vehicleId') return (item.vehicleId ?? '');
      if (key == 'id') return (item.id ?? '');
      if (key == 'plate') return (item.plate ?? '-');
      if (key == 'serie') return (item.serie ?? '-');
      if (key == 'name') return (item.name ?? '-');
      if (key == 'operationState') return (item.operationState ?? 'DISPONIBLE');
      if (key == 'serviceReason') return (item.serviceReason ?? '-');
      if (key == 'serviceDate') return (item.serviceDate ?? null);
      if (key == 'responsible') return (item.responsible ?? '-');
      if (key == 'phone') return (item.phone ?? '-');
      if (key == 'checkoutDate') return (item.checkoutDate ?? null);
      if (key == 'currentLocation') return (item.currentLocation ?? '-');
      if (key == 'solicitantsName') return (item.solicitantsName ?? '-');
      if (key == 'loanComment') return (item.loanComment ?? '-');
      if (key == 'model') return (item.model ?? '-');
      if (key == 'size') return (item.size ?? '-');
      if (key == 'volts') return (item.volts ?? '-');
      if (key == 'unit') return (item.unit ?? '-');
      if (key == 'mileage') return (item.mileage ?? '-');
      if (key == 'company') return (item.company ?? '-');
      if (key == 'email') return (item.email ?? '-');
      // Acceso seguro para minas
      if (key == 'mines') return (item.mines ?? []);
    } catch (e) {
      return '-';
    }
    return '-';
  }

  String _normalizeState(String? state) {
    if (state == null) return "DISPONIBLE";
    String s = state.toUpperCase().trim();
    if (s.contains('IN_SERVICE') || s.contains('MANTENIMIENTO'))
      return "MANTENIMIENTO";
    if (s.contains('LOANED') ||
        s.contains('PRESTAMO') ||
        s.contains('EN PRÉSTAMO'))
      return "LOANED";
    if (s.contains('DISPONIBLE') || s.contains('AVAILABLE'))
      return "DISPONIBLE";
    return "OPERATIVO";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String state = _normalizeState(_val('operationState').toString());

    String title = "";
    IconData icon = Icons.info_outline;

    if (type == "vehiculo") {
      title = "Placa: ${_val('plate')}";
      icon = Icons.local_shipping_rounded;
    } else if (type == "prensa") {
      title = "Serie: ${_val('serie')}";
      icon = Icons.precision_manufacturing_rounded;
    } else {
      title = "Cliente: ${_val('name')}";
      icon = Icons.business_rounded;
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450, maxHeight: 850),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: primaryRed,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (type != "cliente")
                          Text(
                            "ESTADO: ${_val('operationState')}",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildContentByType(state),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryRed,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () async {
                          final String id = type == "vehiculo"
                              ? _val('vehicleId')
                              : _val('id');

                              if (type == "cliente") {
                                print("type: " + type);
                                if (id != '-' && id.isNotEmpty) {
                                  // Cargar datos y navegar a página de historial
                                  await ref
                                      .read(clientHistoryProvider.notifier)
                                      .loadHistory(id);

                                  if (context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ClientHistoryPage(clientId: id),
                                      ),
                                    );
                                  }
                                }
                              } else if (type != "vehiculo") {
                            print("type: " + type);
                            if (id != '-' && id.isNotEmpty) {
                              // Cargar datos y navegar a página de historial
                              await ref
                                  .read(pressHistoryProvider.notifier)
                                  .loadHistory(id);

                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
PressHistoryPage(pressId: id, title: title),
                                  ),
                                );
                              }
                            }
                          } else {
                            print("type: " + type);
                            if (id != '-' && id.isNotEmpty) {
                              // Cargar datos y navegar a página de historial
                              await ref
                                  .read(vehicleHistoryProvider.notifier)
                                  .loadHistory(id);

                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        HistoryPage(assetId: id, title: title),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: const Text(
                          "HISTORIAL",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentByType(String state) {
    if (type == "vehiculo") return _buildVehicleLayout(state);
    if (type == "prensa") return _buildPrensaLayout(state);
    return _buildClientLayout();
  }

  Widget _buildPrensaLayout(String state) {
    if (state == "MANTENIMIENTO") {
      return Column(
        children: [
          _buildFieldRow([
            _buildTile("MOTIVO", _val('serviceReason')),
            _buildTile("FECHA", _formatDate(_val('serviceDate'))),
          ]),
          _buildFieldRow([
            _buildTile("RESPONSABLE", _val('responsible')),
            _buildTile("CONTACTO", _val('phone')),
          ]),
        ],
      );
    } else if (state == "LOANED") {
      return Column(
        children: [
          _buildFieldRow([
            _buildTile("SOLICITANTE", _val('responsible')),
            _buildTile("FECHA", _formatDate(_val('checkoutDate'))),
          ]),
          _buildFieldRow([
            _buildTile("COMENTARIO", _val('loanComment')),
            _buildTile("UBICACIÓN", _val('currentLocation')),
          ]),
        ],
      );
    } else if (state == "DISPONIBLE") {
      return Column(
        children: [
          _buildFieldRow([
            _buildTile("SERIE", _val('serie')),
            _buildTile("MODELO", _val('model')),
          ]),
          _buildFieldRow([
            _buildTile("TAMAÑO", _val('size')),
            _buildTile("VOLTAJE", _val('volts')),
          ]),
        ],
      );
    } else {
      return Column(
        children: [
          _buildFieldRow([
            _buildTile("SALIDA DEF", _formatDate(_val('checkoutDate'))),
            _buildTile("UBICACIÓN", _val('currentLocation')),
          ]),
          _buildFieldRow([
            _buildTile("RESPONSABLE", _val('responsible')),
            _buildTile("CONTACTO", _val('phone')),
          ]),
        ],
      );
    }
  }

  Widget _buildVehicleLayout(String state) {
    return Column(
      children: [
        _buildFieldRow([
          _buildTile("SALIDA", _formatDate(_val('checkoutDate'))),
          _buildTile("RESPONSABLE", _val('responsible')),
        ]),
        _buildFieldRow([
          _buildTile("CONTACTO", _val('phone')),
          _buildTile("UNIDAD", _val('unit')),
        ]),
        _buildTile("UBICACIÓN", _val('currentLocation')),
      ],
    );
  }
Widget _buildClientLayout() {
    final List<dynamic> mines = (_val('mines') as List<dynamic>?) ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTile("COMPAÑÍA", _val('company')),
        _buildFieldRow([
          _buildTile("TELÉFONO", _val('phone')),
          _buildTile("E-MAIL", _val('email')),
        ]),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            "MINAS ASOCIADAS",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.blueGrey,
              letterSpacing: 0.5,
            ),
          ),
        ),
        if (mines.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: const Text(
              "No hay minas registradas",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey, 
                fontSize: 13, 
                fontWeight: FontWeight.w600
              ),
            ),
          ),

        ...mines.map((mina) {
          final name = (mina is Map)
              ? (mina['name'] ?? 'Sin nombre')
              : (mina.name ?? 'Sin nombre');
          final address = (mina is Map)
              ? (mina['address'] ?? 'Sin dirección')
              : (mina.address ?? 'Sin dirección');
          final phone = (mina is Map)
              ? (mina['phone'] ?? '-')
              : (mina.phone ?? '-');

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryRed.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.landscape_rounded,
                          color: primaryRed,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: Colors.grey.shade800,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 15,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                address,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 15,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              phone,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildFieldRow(List<Widget> children) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: children
          .map(
            (c) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: c,
              ),
            ),
          )
          .toList(),
    ),
  );

  Widget _buildTile(String label, dynamic value) => Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.only(bottom: 8),
    width: double.infinity,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
        Text(
          value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    ),
  );

  String _formatDate(dynamic date) =>
      (date == null || date.toString() == 'null' || date.toString().isEmpty)
      ? "-"
      : date.toString().split('T')[0];
}
