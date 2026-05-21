import 'package:flutter/material.dart';

class AssetDetailModal extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
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
            Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
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
                        onPressed: () {},
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
    // Obtenemos la lista de minas desde el objeto item
    // _val('mines') nos devuelve la lista de objetos MineModel
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
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "MINAS ASOCIADAS",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        // Si no hay minas, mostramos un mensaje amigable
        if (mines.isEmpty) 
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text("No hay minas registradas", style: TextStyle(fontSize: 12)),
          ),
        
        // Iteramos sobre la lista de minas
        ...mines.map((mina) {
          // Si la mina viene como Map (JSON puro) o como Objeto MineModel
          final name = (mina is Map) ? (mina['name'] ?? 'Sin nombre') : (mina.name ?? 'Sin nombre');
          final address = (mina is Map) ? (mina['address'] ?? 'Sin dirección') : (mina.address ?? 'Sin dirección');
          final phone = (mina is Map) ? (mina['phone'] ?? '-') : (mina.phone ?? '-');
          final email = (mina is Map) ? (mina['email'] ?? '-') : (mina.email ?? '-');
          
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              borderRadius: BorderRadius.circular(12),
              color: Colors.blue.shade50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text("📍 $address", style: const TextStyle(fontSize: 11)),
                Text("📞 $phone | ✉️ $email", style: const TextStyle(fontSize: 11)),
              ],
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